# Importing Data Fundamentals — Proof of Work #4
## Global GovTech CSV-to-Graph Import Pipeline

This public Proof of Work demonstrates a **repeatable, source-aware Neo4j ingestion pipeline** that transforms small, denormalized CSV source files into a canonical GovTech graph.

It extends the learning lineage of PoW #1 (Neo4j Fundamentals), PoW #2 (Cypher Fundamentals), and PoW #3 (Graph Data Modeling Fundamentals) with the core capability from **Importing Data Fundamentals**: source assessment, source-to-target mapping, stable identity, constraints, typed graph creation, relationship resolution, idempotent re-runs, and deterministic validation.

> **Public-safe boundary:** this artifact uses only public, official-source-backed information about globally known digital-government systems. It does not represent ArquiFácil, AEther, Intellecto, MJD, an employer environment, customer data, private architecture, proprietary prompts, or confidential information.

## Course credential

- Neo4j GraphAcademy: **Importing Data Fundamentals**
- Verification ID: `8a26786e-0932-4e3f-b2f4-4e67392c42fd`
- Credential: https://graphacademy.neo4j.com/c/8a26786e-0932-4e3f-b2f4-4e67392c42fd/

## Architecture question

> How can denormalized, official-source-backed CSV data be transformed into a canonical Neo4j graph without allowing the source file structure to dictate the target model?

## Source files

Two intentionally simple CSV sources are used:

- `data/source/govtech_systems.csv` — combines organization, system, and evidence fields in each row.
- `data/source/system_capabilities.csv` — repeats system IDs and capability-domain values across system-capability observations.

The source shape is **not** copied one-row-to-one-node. The import process decomposes each row into canonical entities and relationships.

## Target graph model

```text
(:PublicOrganization)-[:RESPONSIBLE_FOR]->(:GovTechSystem)
(:GovTechSystem)-[:DOCUMENTED_BY]->(:Evidence)
(:GovTechSystem)-[:ENABLES]->(:Capability)
(:Capability)-[:IN_DOMAIN]->(:CapabilityDomain)
```

Stable identifiers:

- `PublicOrganization.id`
- `GovTechSystem.id`
- `Evidence.id`
- `Capability.id`
- `CapabilityDomain.name`

## Import method

The GraphAcademy course demonstrates Neo4j Data Importer for controlled visual imports. This PoW keeps the same learning principles but implements the final artifact with **Cypher `LOAD CSV`** so it can be executed and validated deterministically in CI.

That tool choice is deliberate:

- Data Importer is excellent for manual prototyping and clean CSV/TSV mapping.
- A public PoW needs a repeatable automated runtime path.
- `LOAD CSV` makes the source-to-target mapping reviewable as code.

## Pipeline

```text
Official public sources
        ↓
Curated CSV source layer
        ↓
Source assessment
        ↓
Mapping specification
        ↓
Constraints / stable IDs
        ↓
LOAD CSV transformation
        ↓
Canonical graph
        ↓
Validation
        ↓
Second import run
        ↓
Idempotence validation
```

## What this demonstrates

- source format, quality, frequency and identity assessment;
- explicit separation between source schema and target graph model;
- typed property conversion and stable identity;
- constraint-backed `MERGE` semantics;
- one source row feeding multiple graph entities and relationships;
- endpoint resolution for relationship creation;
- idempotent re-runs without duplicate graph entities;
- deterministic runtime validation in Docker and GitHub Actions.

## Validation gate

PoW #4 passes only when:

- all expected node and relationship counts match;
- stable identifier constraints exist;
- no duplicate canonical IDs exist;
- no required identifiers are missing;
- official evidence URLs remain attached to the correct systems;
- a second identical import leaves graph cardinalities unchanged;
- CI emits `VALIDATION_RESULT=PASS`.

## Runtime evidence

The successful CI run `36348131374` returned `VALIDATION_RESULT=PASS`, including an explicit `PASS idempotent_rerun=true`. Persistent evidence is recorded in `evidence/ci-validation-2026-09-27.md`.

## Claims boundary

This PoW supports a foundational claim in Neo4j data ingestion, CSV source assessment, source-to-target graph mapping, stable identity, constraint-backed idempotence, relationship import, and deterministic validation.

It does **not** claim production ETL engineering, streaming ingestion, change-data-capture, enterprise-scale import throughput, production data governance, or real-time integration.
