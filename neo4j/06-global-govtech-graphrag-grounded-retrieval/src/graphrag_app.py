from __future__ import annotations

import json
import math
import re
from pathlib import Path
from typing import Any

from neo4j import GraphDatabase
from neo4j_graphrag.embeddings.base import Embedder
from neo4j_graphrag.generation import GraphRAG
from neo4j_graphrag.indexes import create_vector_index
from neo4j_graphrag.llm import LLMInterface
from neo4j_graphrag.llm.types import LLMResponse
from neo4j_graphrag.retrievers import VectorCypherRetriever, VectorRetriever

EMBEDDING_DIMENSION = 10
INDEX_NAME = "govtechEvidence"

FEATURES = [
    ("authentication", ("authentication", "authenticate", "sign in", "login", "account")),
    ("identity", ("identity", "prove", "verification", "verify", "digital identity")),
    ("signature", ("signature", "sign documents", "electronic signatures", "signing")),
    ("consent", ("consent", "permission")),
    ("sharing", ("sharing", "share", "myinfo", "pre-fill")),
    ("exchange", ("exchange", "data exchange", "produce", "consume")),
    ("interoperability", ("interoperability", "interoperable")),
    ("security", ("secure", "security", "confidentiality", "integrity", "encryption")),
    ("government", ("government", "public")),
    ("integration", ("integrate", "integration", "service", "services")),
]

class DeterministicKeywordEmbedder(Embedder):
    def embed_query(self, text: str) -> list[float]:
        lowered = text.lower()
        values = [float(sum(lowered.count(term) for term in terms)) for _, terms in FEATURES]
        norm = math.sqrt(sum(value * value for value in values))
        if norm == 0:
            values[-1] = 1.0
            norm = 1.0
        return [value / norm for value in values]

class DeterministicGroundedLLM(LLMInterface):
    KNOWN_SYSTEMS = ("GOV.UK One Login", "Login.gov", "Singpass", "X-Road")
    URL_PATTERN = re.compile(r"https://[^\\s'\\\"},]+")

    def __init__(self) -> None:
        super().__init__(model_name="deterministic-grounded-test-double")
        self.last_input = ""

    def _answer(self, prompt: str) -> str:
        self.last_input = prompt
        systems = [name for name in self.KNOWN_SYSTEMS if name in prompt]
        urls = []
        for match in self.URL_PATTERN.findall(prompt):
            clean = match.rstrip(").]")
            if clean not in urls:
                urls.append(clean)
        return (
            "Grounded from retrieved Neo4j context. "
            f"Systems present in context: {', '.join(systems) if systems else 'no named system'}. "
            f"Evidence sources present in context: {', '.join(urls[:4]) if urls else 'no source URL'}."
        )

    def invoke(self, input: str, message_history: Any = None, system_instruction: str | None = None) -> LLMResponse:
        return LLMResponse(content=self._answer(input))

    async def ainvoke(self, input: str, message_history: Any = None, system_instruction: str | None = None) -> LLMResponse:
        return self.invoke(input, message_history, system_instruction)

class GovTechGraphRAGApp:
    def __init__(self, uri: str, username: str, password: str, database: str = "neo4j"):
        self.database = database
        self.driver = GraphDatabase.driver(uri, auth=(username, password))
        self.embedder = DeterministicKeywordEmbedder()
        self.llm = DeterministicGroundedLLM()

    def __enter__(self) -> "GovTechGraphRAGApp":
        self.driver.verify_connectivity()
        return self

    def __exit__(self, exc_type: Any, exc: Any, traceback: Any) -> None:
        self.driver.close()

    def reset(self) -> None:
        self.driver.execute_query("MATCH (n) DETACH DELETE n", database_=self.database)
        self.driver.execute_query(f"DROP INDEX {INDEX_NAME} IF EXISTS", database_=self.database)

    def create_constraints(self) -> None:
        statements = [
            "CREATE CONSTRAINT govtech_system_id IF NOT EXISTS FOR (s:GovTechSystem) REQUIRE s.id IS UNIQUE",
            "CREATE CONSTRAINT public_org_name IF NOT EXISTS FOR (o:PublicOrganization) REQUIRE o.name IS UNIQUE",
            "CREATE CONSTRAINT evidence_id IF NOT EXISTS FOR (e:Evidence) REQUIRE e.id IS UNIQUE",
            "CREATE CONSTRAINT capability_name IF NOT EXISTS FOR (c:Capability) REQUIRE c.name IS UNIQUE",
        ]
        for statement in statements:
            self.driver.execute_query(statement, database_=self.database)

    def seed(self, data_path: str | Path) -> None:
        records = json.loads(Path(data_path).read_text(encoding="utf-8"))
        for row in records:
            embedding = self.embedder.embed_query(row["evidence_text"])
            self.driver.execute_query(
                """
                MERGE (o:PublicOrganization {name: $organization})
                MERGE (s:GovTechSystem {id: $system_id})
                SET s.name = $system_name, s.jurisdiction = $jurisdiction
                MERGE (o)-[:RESPONSIBLE_FOR]->(s)
                MERGE (e:Evidence {id: $evidence_id})
                SET e.text = $evidence_text, e.sourceUrl = $source_url, e.embedding = $embedding
                MERGE (s)-[:DOCUMENTED_BY]->(e)
                WITH s
                UNWIND $capabilities AS capability
                MERGE (c:Capability {name: capability})
                MERGE (s)-[:ENABLES]->(c)
                """,
                parameters_=dict(row, embedding=embedding),
                database_=self.database,
            )

    def create_vector_index(self) -> None:
        create_vector_index(
            self.driver,
            INDEX_NAME,
            label="Evidence",
            embedding_property="embedding",
            dimensions=EMBEDDING_DIMENSION,
            similarity_fn="cosine",
            fail_if_exists=False,
            neo4j_database=self.database,
        )
        self.driver.execute_query("CALL db.awaitIndexes(60)", database_=self.database)

    def counts(self) -> dict[str, int]:
        records, _, _ = self.driver.execute_query(
            """
            MATCH (s:GovTechSystem)
            WITH count(s) AS systems
            MATCH (e:Evidence)
            WITH systems, count(e) AS evidence
            MATCH (c:Capability)
            WITH systems, evidence, count(c) AS capabilities
            MATCH ()-[r:ENABLES]->()
            RETURN systems, evidence, capabilities, count(r) AS enables
            """,
            database_=self.database,
        )
        return dict(records[0])

    def vector_search(self, query_text: str, top_k: int = 3):
        retriever = VectorRetriever(
            self.driver,
            index_name=INDEX_NAME,
            embedder=self.embedder,
            return_properties=["id", "text", "sourceUrl"],
            neo4j_database=self.database,
        )
        return retriever.search(query_text=query_text, top_k=top_k)

    def _graph_retriever(self):
        retrieval_query = """
        MATCH (system:GovTechSystem)-[:DOCUMENTED_BY]->(node)
        OPTIONAL MATCH (organization:PublicOrganization)-[:RESPONSIBLE_FOR]->(system)
        OPTIONAL MATCH (system)-[:ENABLES]->(capability:Capability)
        RETURN system.id AS system_id,
               system.name AS system,
               system.jurisdiction AS jurisdiction,
               organization.name AS organization,
               node.id AS evidence_id,
               node.text AS evidence,
               node.sourceUrl AS source_url,
               score AS similarity_score,
               collect(DISTINCT capability.name) AS capabilities
        """
        return VectorCypherRetriever(
            self.driver,
            index_name=INDEX_NAME,
            retrieval_query=retrieval_query,
            embedder=self.embedder,
            neo4j_database=self.database,
        )

    def graph_enhanced_search(self, query_text: str, top_k: int = 3):
        return self._graph_retriever().search(query_text=query_text, top_k=top_k)

    def graphrag_search(self, query_text: str, top_k: int = 3):
        rag = GraphRAG(retriever=self._graph_retriever(), llm=self.llm)
        return rag.search(query_text=query_text, retriever_config={"top_k": top_k}, return_context=True)
