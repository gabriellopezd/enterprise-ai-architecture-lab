from __future__ import annotations

import math
import re
from typing import Any, Iterable

from neo4j import GraphDatabase, RoutingControl
from neo4j_graphrag.generation import GraphRAG
from neo4j_graphrag.llm import LLMBase, LLMResponse
from neo4j_graphrag.retrievers import VectorCypherRetriever
from neo4j_graphrag.types import RetrieverResultItem


VECTOR_INDEX_NAME = "govtechEvidenceEmbeddings"

VOCABULARY = (
    "authentication",
    "identity",
    "verification",
    "signature",
    "consent",
    "data",
    "exchange",
    "interoperability",
)

SYSTEMS = [
    {
        "id": "SYS-001",
        "name": "GOV.UK One Login",
        "jurisdiction": "United Kingdom",
        "source_url": "https://docs.sign-in.service.gov.uk/",
        "evidence_id": "EVID-001",
        "evidence_title": "GOV.UK One Login technical documentation",
        "summary": (
            "Public technical documentation for GOV.UK One Login, represented in this "
            "learning graph around authentication and identity verification."
        ),
        "capability_ids": ["CAP-001", "CAP-002"],
    },
    {
        "id": "SYS-002",
        "name": "Login.gov",
        "jurisdiction": "United States",
        "source_url": "https://www.login.gov/about-us/",
        "evidence_id": "EVID-002",
        "evidence_title": "Login.gov public information",
        "summary": (
            "Public information about Login.gov, represented in this learning graph "
            "around authentication and identity verification."
        ),
        "capability_ids": ["CAP-001", "CAP-002"],
    },
    {
        "id": "SYS-003",
        "name": "Singpass",
        "jurisdiction": "Singapore",
        "source_url": "https://developer.singpass.gov.sg/",
        "evidence_id": "EVID-003",
        "evidence_title": "Singpass developer documentation",
        "summary": (
            "Public developer documentation for Singpass, represented in this learning "
            "graph around digital identity, authentication, digital signature and "
            "consent-based data sharing."
        ),
        "capability_ids": ["CAP-003", "CAP-001", "CAP-004", "CAP-005"],
    },
    {
        "id": "SYS-004",
        "name": "X-Road",
        "jurisdiction": "Cross-border / international",
        "source_url": "https://x-road.global/x-road-technology-overview",
        "evidence_id": "EVID-004",
        "evidence_title": "X-Road technology overview",
        "summary": (
            "Public technology overview for X-Road, represented in this learning graph "
            "around secure data exchange and interoperability."
        ),
        "capability_ids": ["CAP-006", "CAP-007"],
    },
]

CAPABILITIES = [
    {"id": "CAP-001", "name": "Authentication"},
    {"id": "CAP-002", "name": "Identity Verification"},
    {"id": "CAP-003", "name": "Digital Identity"},
    {"id": "CAP-004", "name": "Digital Signature"},
    {"id": "CAP-005", "name": "Consent-Based Data Sharing"},
    {"id": "CAP-006", "name": "Secure Data Exchange"},
    {"id": "CAP-007", "name": "Interoperability"},
]


class DeterministicSemanticEmbedder:
    """Small deterministic embedder used only as a secret-free CI test double."""

    dimensions = len(VOCABULARY)

    def embed_query(self, text: str) -> list[float]:
        tokens = re.findall(r"[a-z]+", text.lower())
        values = [float(tokens.count(term)) for term in VOCABULARY]
        magnitude = math.sqrt(sum(value * value for value in values))
        if magnitude == 0.0:
            # Cosine indexes cannot use an all-zero query vector.
            values[-1] = 1e-6
            magnitude = 1e-6
        return [value / magnitude for value in values]


class EvidenceBoundLLM(LLMBase):
    """Deterministic LLM-interface test double that can only echo retrieved evidence."""

    def __init__(self) -> None:
        super().__init__(model_name="evidence-bound-ci-test-double")
        self.last_input = ""

    @staticmethod
    def _to_text(input_value: Any) -> str:
        if isinstance(input_value, str):
            return input_value

        parts: list[str] = []
        if isinstance(input_value, Iterable):
            for item in input_value:
                if isinstance(item, dict):
                    parts.append(str(item.get("content", item)))
                else:
                    parts.append(str(getattr(item, "content", item)))
        return "\n".join(parts)

    def invoke(
        self,
        input: Any,
        message_history: Any = None,
        system_instruction: str | None = None,
        response_format: Any = None,
        **kwargs: Any,
    ) -> LLMResponse:
        prompt = self._to_text(input)
        self.last_input = prompt

        grounded = [
            (row["name"], row["source_url"])
            for row in SYSTEMS
            if row["name"] in prompt and row["source_url"] in prompt
        ]

        if not grounded:
            return LLMResponse(
                content="No grounded answer can be produced from the retrieved context."
            )

        lines = [
            f"- {name} — {source_url}"
            for name, source_url in grounded
        ]
        return LLMResponse(
            content=(
                "Grounded answer from retrieved public evidence:\n"
                + "\n".join(lines)
            )
        )

    async def ainvoke(
        self,
        input: Any,
        message_history: Any = None,
        system_instruction: str | None = None,
        response_format: Any = None,
        **kwargs: Any,
    ) -> LLMResponse:
        return self.invoke(
            input,
            message_history=message_history,
            system_instruction=system_instruction,
            response_format=response_format,
            **kwargs,
        )


def govtech_result_formatter(record: Any) -> RetrieverResultItem:
    capabilities = list(record.get("capabilities") or [])
    source_url = record.get("sourceUrl")
    system_name = record.get("systemName")
    score = record.get("similarityScore")

    content = "\n".join(
        [
            f"System: {system_name}",
            f"Jurisdiction: {record.get('jurisdiction')}",
            f"Evidence: {record.get('evidenceTitle')}",
            f"Evidence summary: {record.get('evidenceSummary')}",
            f"Capabilities: {', '.join(capabilities)}",
            f"Official source: {source_url}",
        ]
    )

    return RetrieverResultItem(
        content=content,
        metadata={
            "system_name": system_name,
            "source_url": source_url,
            "capabilities": capabilities,
            "score": score,
        },
    )


class GovTechGraphRAG:
    """Public-safe GraphRAG application used by PoW #6."""

    def __init__(
        self,
        uri: str,
        username: str,
        password: str,
        database: str = "neo4j",
    ) -> None:
        self.database = database
        self.driver = GraphDatabase.driver(uri, auth=(username, password))
        self.embedder = DeterministicSemanticEmbedder()
        self.llm = EvidenceBoundLLM()

    def __enter__(self) -> "GovTechGraphRAG":
        self.driver.verify_connectivity()
        return self

    def __exit__(self, exc_type: Any, exc: Any, traceback: Any) -> None:
        self.driver.close()

    def reset_database(self) -> None:
        self.driver.execute_query(
            "MATCH (n) DETACH DELETE n",
            database_=self.database,
        )
        self.driver.execute_query(
            f"DROP INDEX {VECTOR_INDEX_NAME} IF EXISTS",
            database_=self.database,
        )

    def create_schema(self) -> None:
        statements = [
            (
                "CREATE CONSTRAINT govtech_system_id_006 IF NOT EXISTS "
                "FOR (s:GovTechSystem) REQUIRE s.id IS UNIQUE"
            ),
            (
                "CREATE CONSTRAINT evidence_id_006 IF NOT EXISTS "
                "FOR (e:Evidence) REQUIRE e.id IS UNIQUE"
            ),
            (
                "CREATE CONSTRAINT capability_id_006 IF NOT EXISTS "
                "FOR (c:Capability) REQUIRE c.id IS UNIQUE"
            ),
            f"""
            CREATE VECTOR INDEX {VECTOR_INDEX_NAME} IF NOT EXISTS
            FOR (e:Evidence) ON (e.embedding)
            OPTIONS {{indexConfig: {{
              `vector.dimensions`: {self.embedder.dimensions},
              `vector.similarity_function`: 'cosine'
            }}}}
            """,
        ]
        for statement in statements:
            self.driver.execute_query(statement, database_=self.database)

    def seed_public_graph(self) -> None:
        capability_by_id = {row["id"]: row["name"] for row in CAPABILITIES}

        enriched_systems = []
        for system in SYSTEMS:
            capability_names = [
                capability_by_id[capability_id]
                for capability_id in system["capability_ids"]
            ]
            embedding_text = system["summary"] + " " + " ".join(capability_names)
            enriched_systems.append(
                {
                    **system,
                    "embedding": self.embedder.embed_query(embedding_text),
                }
            )

        self.driver.execute_query(
            """
            UNWIND $capabilities AS row
            MERGE (c:Capability {id: row.id})
            SET c.name = row.name
            """,
            capabilities=CAPABILITIES,
            database_=self.database,
        )

        self.driver.execute_query(
            """
            UNWIND $systems AS row
            MERGE (s:GovTechSystem {id: row.id})
            SET s.name = row.name,
                s.jurisdiction = row.jurisdiction

            MERGE (e:Evidence {id: row.evidence_id})
            SET e.title = row.evidence_title,
                e.summary = row.summary,
                e.url = row.source_url,
                e.embedding = row.embedding

            MERGE (s)-[:DOCUMENTED_BY]->(e)

            WITH s, row
            UNWIND row.capability_ids AS capability_id
            MATCH (c:Capability {id: capability_id})
            MERGE (s)-[:ENABLES]->(c)
            """,
            systems=enriched_systems,
            database_=self.database,
        )

        self.driver.execute_query(
            "CALL db.awaitIndexes(120)",
            database_=self.database,
        )

    def index_state(self) -> str | None:
        records, _, _ = self.driver.execute_query(
            """
            SHOW VECTOR INDEXES
            YIELD name, state
            WHERE name = $name
            RETURN state
            """,
            name=VECTOR_INDEX_NAME,
            database_=self.database,
            routing_=RoutingControl.READ,
        )
        return records[0]["state"] if records else None

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
            routing_=RoutingControl.READ,
        )
        return dict(records[0])

    def embedding_dimensions(self) -> list[int]:
        records, _, _ = self.driver.execute_query(
            """
            MATCH (e:Evidence)
            RETURN size(e.embedding) AS dimensions
            ORDER BY e.id
            """,
            database_=self.database,
            routing_=RoutingControl.READ,
        )
        return [record["dimensions"] for record in records]

    def build_retriever(self) -> VectorCypherRetriever:
        retrieval_query = """
        MATCH (system:GovTechSystem)-[:DOCUMENTED_BY]->(node)
        OPTIONAL MATCH (system)-[:ENABLES]->(capability:Capability)
        WITH node, score, system, collect(DISTINCT capability.name) AS capabilities
        RETURN
          system.name AS systemName,
          system.jurisdiction AS jurisdiction,
          node.title AS evidenceTitle,
          node.summary AS evidenceSummary,
          node.url AS sourceUrl,
          capabilities,
          score AS similarityScore
        ORDER BY similarityScore DESC
        """

        return VectorCypherRetriever(
            driver=self.driver,
            neo4j_database=self.database,
            index_name=VECTOR_INDEX_NAME,
            retrieval_query=retrieval_query,
            embedder=self.embedder,
            result_formatter=govtech_result_formatter,
        )

    def search_context(self, query_text: str, top_k: int = 3):
        retriever = self.build_retriever()
        return retriever.search(query_text=query_text, top_k=top_k)

    def search_graphrag(self, query_text: str, top_k: int = 3):
        retriever = self.build_retriever()
        rag = GraphRAG(retriever=retriever, llm=self.llm)
        return rag.search(
            query_text=query_text,
            retriever_config={"top_k": top_k},
            return_context=True,
        )
