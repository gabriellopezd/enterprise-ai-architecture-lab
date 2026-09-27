# Neo4j & GenerativeAI Fundamentals — Proof of Work #6
## Global GovTech GraphRAG Grounded Retrieval

This public Proof of Work demonstrates a **foundational GraphRAG implementation combining semantic retrieval, graph relationships and grounded generation over public GovTech evidence**.

It extends the learning lineage from graph representation, Cypher, modeling, ingestion and Python application integration into the next capability: **retrieving evidence semantically, enriching it with graph structure, and passing the retrieved context through Neo4j's GraphRAG orchestration path**.

> **Public-safe boundary:** this artifact uses only small, curated statements derived from official public documentation for globally known digital-government systems. It does not represent Intellecto, ArquiFácil, AEther, MJD, an employer environment, customer data, private architecture, proprietary prompts, or confidential information.

## Course credential

- Neo4j GraphAcademy: **Neo4j & GenerativeAI Fundamentals**
- Verification ID: `f0f7ee8e-209b-4de2-8300-f53e2d4e8283`
- Credential: https://graphacademy.neo4j.com/c/f0f7ee8e-209b-4de2-8300-f53e2d4e8283/
- Completed: 2026-09-27
- Category: Context Engineer

## Architecture question

> How can a graph-backed AI application retrieve semantically relevant public evidence, add relationship-aware context, and make the grounding path inspectable without depending on secrets or a paid model during CI?

## Runtime architecture

~~~text
Public official evidence
        |
        v
Neo4j Knowledge Graph
        |
        +--> Evidence.embedding
        |      |
        |      v
        |   Vector index
        |      |
User query --> deterministic embedder
               |
               v
         VectorRetriever
               |
               +--> semantic evidence
               |
               v
      VectorCypherRetriever
               |
               +--> GovTechSystem
               +--> PublicOrganization
               +--> Capability
               +--> official source URL
               |
               v
            GraphRAG
               |
               v
 deterministic grounded LLM test double
               |
               v
 answer + returned retriever context
~~~

## Why the deterministic components exist

CI intentionally does **not** require an OpenAI key or any paid model. The repository uses a small deterministic keyword embedder to produce reproducible vectors and a GraphRAG-compatible deterministic LLM test double that builds its answer only from names and source URLs actually present in the formatted retrieved context.

This lets CI verify the **retrieval, graph enrichment, context propagation and GraphRAG orchestration path** without pretending that provider-backed model quality has been tested. The production-oriented learning is the architecture and integration pattern, not the toy embedding model.

## Public graph model

~~~text
(:PublicOrganization)-[:RESPONSIBLE_FOR]->(:GovTechSystem)
(:GovTechSystem)-[:DOCUMENTED_BY]->(:Evidence)
(:GovTechSystem)-[:ENABLES]->(:Capability)
~~~

## Public evidence

The bounded source register is in [sources.md](./sources.md). The examples are GOV.UK One Login, Login.gov, Singpass and X-Road. The statements are curated learning evidence, not an authoritative registry or a complete comparison.

## What is implemented

- real Neo4j 5.26 runtime in Docker;
- constraints and deterministic public data seeding;
- vector properties on Evidence nodes;
- a Neo4j vector index created through `neo4j-graphrag`;
- `VectorRetriever` semantic retrieval;
- `VectorCypherRetriever` graph-enhanced retrieval;
- traversal from evidence to systems, responsible organizations and capabilities;
- official source URLs returned as grounding metadata;
- a real `GraphRAG` pipeline from the first-party `neo4j-graphrag` package;
- `return_context=True` so the grounding context is inspectable;
- deterministic GraphRAG-compatible generation for secret-free CI;
- runtime assertions proving that retrieved context reaches generation.

The first-party package is pinned to `neo4j-graphrag==1.21.0`.

## Runtime validation

~~~bash
python -m pip install -r requirements.txt
chmod +x scripts/run.sh
./scripts/run.sh
~~~

The gate verifies Neo4j connectivity, graph cardinalities, scored vector retrieval, graph-enhanced context, source provenance, returned GraphRAG context, context propagation into generation, and a grounded answer with source URLs. A successful run ends with `VALIDATION_RESULT=PASS`.

## Architectural learning

~~~text
semantic retrieval
+ graph traversal
+ provenance
+ explicit returned context
+ bounded generation
= inspectable grounding path
~~~

Vector similarity answers “what looks semantically close?” Graph traversal then answers “what is this evidence connected to?” The generation layer receives both evidence and structured relationships, while provenance remains inspectable.

## Claims boundary

This artifact supports only the following claim:

> **Foundational GraphRAG implementation combining semantic retrieval, graph relationships and grounded generation over public GovTech evidence.**

It does **not** establish production GraphRAG quality, production embedding quality, autonomous agents, enterprise-scale retrieval, production security, production observability, model evaluation, hallucination elimination, a production AI system, or any private ArquiFácil/AEther capability.

Provider-backed LLM generation is intentionally outside CI; the deterministic LLM is a test double used to verify context propagation and orchestration.

## Proof-of-work lineage

~~~text
PoW #1  represent
PoW #2  operate
PoW #3  design / refactor
PoW #4  ingest
PoW #5  integrate
PoW #6  ground
~~~
