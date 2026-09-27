# Neo4j / Cypher Fundamentals Proof of Work 001
## Global GovTech Systems Knowledge Graph

This public Proof of Work demonstrates foundational Neo4j and Cypher skills through a small, evidence-backed knowledge graph of **real public digital systems**.

The goal is to connect technical learning with the professional practice of an **Enterprise AI Architect / Digital Transformation Architect**, using a global GovTech lens.

> **Public-safe boundary:** this artifact uses only publicly available information from official sources. It does not represent or disclose any proprietary product, employer architecture, institutional environment, private dataset, customer information, internal metamodel, confidential business logic or non-public government information.

## Why GovTech

Public digital infrastructure and shared government platforms are strong graph-modeling examples because they connect:

- public organizations;
- digital systems and platforms;
- reusable capabilities;
- official documentation and evidence.

This PoW intentionally avoids country-specific market analysis and focuses on globally understandable GovTech patterns.

## Real systems modeled

The graph uses four real, publicly documented systems:

1. **GOV.UK One Login** — authentication and identity verification for UK government services.
2. **Login.gov** — authentication and identity verification for participating U.S. government services.
3. **Singpass** — Singapore's trusted digital identity, including authentication, digital signing and consent-based data sharing through Myinfo.
4. **X-Road** — an open-source, secure and interoperable data exchange layer maintained by NIIS.

Official source references are documented in `sources/official-sources.md`.

## Architecture question

> How can public organizations, digital systems, reusable capabilities and official evidence be represented as a traceable graph?

## Graph model

```text
(:PublicOrganization)
       | OPERATES / MAINTAINS
       v
(:GovTechSystem)
       | ENABLES
       v
(:Capability)

(:GovTechSystem)-[:DOCUMENTED_BY]->(:Evidence)
```

This creates a simple line of sight:

```text
Public organization
        ↓
GovTech system
        ↓
Digital capability
        ↓
Official evidence
```

## Implemented scope

### Public organizations
- Government Digital Service
- U.S. General Services Administration
- Government Technology Agency of Singapore
- Nordic Institute for Interoperability Solutions

### GovTech systems
- GOV.UK One Login
- Login.gov
- Singpass
- X-Road

### Capabilities
- Authentication
- Identity Verification
- Digital Identity
- Digital Signature
- Consent-Based Data Sharing
- Secure Data Exchange
- Interoperability

### Evidence
One official public source is linked to each modeled system.

## Learning goals

This exercise demonstrates the Cypher Fundamentals concepts covered in Neo4j GraphAcademy:

- nodes, labels, relationships and properties;
- `MATCH`, `WHERE`, `RETURN` and `LIMIT`;
- `MERGE` for deterministic node and relationship creation;
- `SET` for properties;
- `ON CREATE` and `ON MATCH`;
- `REMOVE`;
- `DELETE` and `DETACH DELETE`;
- relationship direction;
- reproducibility with Docker;
- deterministic validation with shell scripts.

The destructive/update patterns are isolated in `cypher/05-course-patterns.cypher` and are not required to mutate the evidence graph.

## Structure

```text
01-enterprise-architecture-knowledge-graph/
├── README.md
├── docker-compose.yml
├── model/
│   └── graph-model.md
├── sources/
│   └── official-sources.md
├── cypher/
│   ├── 01-schema.cypher
│   ├── 02-data.cypher
│   ├── 03-queries.cypher
│   ├── 04-validation.cypher
│   └── 05-course-patterns.cypher
├── scripts/
│   ├── run.sh
│   └── validate.sh
└── evidence/
    └── expected-validation.txt
```

## Run locally

Requirements:

- Docker Desktop or Docker Engine
- Docker Compose v2
- Bash

From this directory:

```bash
chmod +x scripts/*.sh
./scripts/run.sh
```

The script starts Neo4j, loads the curated public-source graph, runs sample Cypher queries and validates the expected graph deterministically.

## Example query 1 — systems that enable authentication

```cypher
MATCH (s:GovTechSystem)-[:ENABLES]->(c:Capability)
WHERE c.name = 'Authentication'
RETURN s.name AS system, s.jurisdiction AS jurisdiction
ORDER BY system
LIMIT 10;
```

## Example query 2 — trace system to official evidence

```cypher
MATCH (o:PublicOrganization)-[:OPERATES]->(s:GovTechSystem)-[:DOCUMENTED_BY]->(e:Evidence)
RETURN o.name AS organization,
       s.name AS system,
       e.title AS source,
       e.url AS url
ORDER BY system
LIMIT 10;
```

## Expected validation

```text
PASS organizations=4
PASS systems=4
PASS capabilities=7
PASS evidence=4
PASS operates=3
PASS maintains=1
PASS enables=10
PASS documented_by=4
PASS required_patterns=MATCH,WHERE,RETURN,MERGE,SET,REMOVE,DELETE,DETACH DELETE,ON CREATE,ON MATCH,LIMIT
VALIDATION_RESULT=PASS
```

## What this proves

This artifact supports a **foundational** claim in:

- Neo4j property graphs;
- foundational Cypher;
- graph-based representation of real GovTech systems;
- capability traceability;
- evidence-backed modeling;
- architecture-oriented reasoning;
- reproducible technical experimentation.

## What this does not prove

It does not claim:

- advanced Neo4j expertise;
- production knowledge graphs;
- production GraphRAG;
- production AI agents;
- enterprise-scale graph operations;
- production cloud architecture;
- production security engineering;
- completeness of the modeled public systems.

## Claims boundary

The systems and capabilities are modeled only to the extent supported by the official sources listed in this repository. The graph is an educational abstraction, not an authoritative architecture of those government platforms.

## Professional capability signal

The value of the PoW is not only the use of Neo4j.

It demonstrates a repeatable professional pattern:

```text
Public evidence
     ↓
Architecture abstraction
     ↓
Graph model
     ↓
Cypher implementation
     ↓
Validation
     ↓
Reproducible Proof of Work
```

Future PoWs in this lab should continue using a **global GovTech + public evidence + privacy-safe** framing whenever the subject permits.
