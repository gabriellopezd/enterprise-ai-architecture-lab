# Neo4j & GenerativeAI Fundamentals — Proof of Work #6
## Global GovTech GraphRAG Grounded Retrieval

This public Proof of Work demonstrates a small, executable **GraphRAG grounding pipeline over Neo4j** using public-safe GovTech evidence.

It extends the learning lineage from graph representation, Cypher, data modeling, ingestion and Python application integration into the next capability: **semantic retrieval + graph traversal + grounded answer generation through the official `neo4j-graphrag` package**.

> **Public-safe boundary:** this artifact uses only public, official-source-backed examples of globally known digital-government systems. It does not represent ArquiFácil, AEther, Intellecto, MJD, an employer environment, customer data, private architecture, proprietary prompts, credentials, or confidential information.

## Course credential

- Neo4j GraphAcademy: **Neo4j & GenerativeAI Fundamentals**
- Completed: **September 27, 2026**
- Verification ID: `f0f7ee8e-209b-4de2-8300-f53e2d4e8283`
- Credential: https://graphacademy.neo4j.com/c/f0f7ee8e-209b-4de2-8300-f53e2d4e8283/

## Architecture question

> How can a Neo4j knowledge graph combine vector retrieval and graph relationships so that an answer is generated from inspectable public evidence rather than from an ungrounded model response?

## Runtime architecture

~~~text
User question
    |
    v
Deterministic semantic embedder
(CI-safe test double; no external API)
    |
    v
Neo4j vector index on Evidence.embedding
    |
    v
VectorCypherRetriever
    |
    +--> vector similarity
    |
    +--> graph traversal
            Evidence
              ^
              | DOCUMENTED_BY
        GovTechSystem
              |
              +--> ENABLES --> Capability
    |
    v
Retrieved context
(system + evidence + capabilities + official source URL)
    |
    v
neo4j-graphrag GraphRAG
    |
    v
Evidence-bound LLM interface test double
    |
    v
Grounded answer + inspectable retriever context
~~~

## Public evidence used

The graph reuses the public-safe GovTech lineage established in prior PoWs:

- **GOV.UK One Login** — Government Digital Service — https://docs.sign-in.service.gov.uk/
- **Login.gov** — U.S. General Services Administration — https://www.login.gov/about-us/
- **Singpass** — Government Technology Agency of Singapore — https://developer.singpass.gov.sg/
- **X-Road** — Nordic Institute for Interoperability Solutions — https://x-road.global/x-road-technology-overview

The records are intentionally small, curated learning inputs derived from official public documentation. They are not presented as authoritative registries, exhaustive capability catalogs, or production datasets.

## What is implemented

The executable PoW demonstrates:

- a Neo4j knowledge graph with `GovTechSystem`, `Evidence` and `Capability` nodes;
- official public evidence URLs attached to retrieved context;
- an 8-dimensional vector property on `Evidence` nodes;
- a Neo4j vector index using cosine similarity;
- a custom deterministic embedder that implements the retriever embedding contract without requiring an external API key;
- `VectorCypherRetriever` from the first-party `neo4j-graphrag` package;
- graph traversal after vector retrieval to enrich context with the documented system and its capabilities;
- a custom result formatter that makes grounding evidence explicit to the generation layer;
- `GraphRAG` retrieval → augmentation → generation wiring;
- a deterministic evidence-bound LLM interface used as a CI test double;
- `return_context=True` so the evidence supplied to generation can be inspected;
- automated validation that answer URLs are a subset of URLs present in retrieved context.

## Why deterministic test doubles are used in CI

This repository must be reproducible without publishing secrets or depending on a paid external model endpoint.

The runtime therefore uses:

1. a small deterministic semantic embedder for query/evidence vectors; and
2. an evidence-bound `LLMBase` implementation that only composes an answer from context actually present in the GraphRAG prompt.

These components exercise the **Neo4j vector index, VectorCypherRetriever, graph traversal, result formatting and GraphRAG orchestration contracts** while keeping CI secret-free and deterministic.

They are explicitly **test doubles**, not claims of model quality, production embeddings, or a production LLM.

## Retrieval patterns demonstrated

### Semantic retrieval

A natural-language question is embedded and compared against `Evidence.embedding`.

### Graph-enhanced retrieval

The vector match is only the entry point. The retrieval query traverses:

~~~text
(GovTechSystem)-[:DOCUMENTED_BY]->(Evidence)
(GovTechSystem)-[:ENABLES]->(Capability)
~~~

The context given to the generation layer therefore includes graph facts that are not merely vector-neighbor metadata.

### Grounding and transparency

The generated answer contains only source URLs found in the retrieved context, and the validation gate verifies that boundary.

## Automated validation

`scripts/run.sh` starts a fresh Neo4j container and executes the integration validator.

The gate checks:

- Neo4j driver connectivity;
- graph cardinalities: 4 systems, 4 evidence nodes, 7 capabilities and 10 `ENABLES` relationships;
- the vector index exists and is online;
- all evidence embeddings have exactly 8 dimensions;
- semantic retrieval for authentication returns the three expected identity/sign-in systems and excludes X-Road;
- vector retrieval for secure data exchange and interoperability ranks X-Road first;
- graph traversal enriches retrieved evidence with capabilities and official source URLs;
- `GraphRAG.search(..., return_context=True)` returns inspectable context;
- the generation prompt contains retrieved graph evidence;
- the answer contains grounded public evidence URLs;
- every URL emitted in the answer is present in retrieved context;
- the run emits `VALIDATION_RESULT=PASS`.

Run locally:

~~~bash
python -m pip install -r requirements.txt
chmod +x scripts/run.sh
./scripts/run.sh
~~~

## Architectural learning

The control boundary introduced by this PoW is:

~~~text
user question
+ embedding contract
+ vector index
+ graph traversal
+ retrieved evidence
+ explicit source URLs
+ generation contract
+ returned context
= inspectable grounded retrieval pipeline
~~~

GraphRAG is not simply “RAG with a vector database.” The graph lets retrieval expand from a semantically similar evidence node into connected entities, capabilities and provenance that can be returned as structured, explainable context.

## Text-to-Cypher transfer

The course also introduced Text-to-Cypher. It is intentionally **not executed by an unconstrained model in this public CI**. Production use would require schema scoping, least-privilege access, read/write controls, query validation, exception handling and limits before executing model-generated Cypher.

That omission is deliberate: demonstrating GraphRAG retrieval safely is stronger evidence than executing unvalidated generated queries merely to increase feature count.

## Claims boundary

This PoW supports a foundational claim in **Neo4j GraphRAG application patterns**: vector retrieval over Neo4j evidence, graph-enhanced context, first-party `neo4j-graphrag` orchestration, explicit provenance in context, and deterministic integration validation.

It does **not** claim production GraphRAG, production embedding quality, production LLM quality, autonomous agents, enterprise-scale retrieval, production security hardening, production observability, production deployment, or unrestricted Text-to-Cypher execution.

## Proof-of-work lineage

~~~text
PoW #1  represent
PoW #2  operate
PoW #3  design / refactor
PoW #4  ingest
PoW #5  integrate
PoW #6  ground / retrieve
~~~
