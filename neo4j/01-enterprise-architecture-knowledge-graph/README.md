# Neo4j Fundamentals Proof of Work 001
## Enterprise Architecture Knowledge Graph

This public Proof of Work demonstrates foundational Neo4j and Cypher skills through a small, synthetic Enterprise Architecture knowledge graph.

> **Privacy boundary:** this example is intentionally generic and uses fictitious data. It does not represent the architecture, metamodel, data model, business logic or implementation of any proprietary product.

## Learning goals

This exercise demonstrates:

- property graph modeling;
- nodes, labels, relationships and properties;
- `MERGE` and `SET` for deterministic creation/update;
- `MATCH`, `WHERE`, `RETURN` and `LIMIT` for querying;
- basic traversal across several node types;
- reproducibility with Docker;
- automated validation with GitHub Actions.

## Graph model

```text
(:Organization)
      |
      | HAS_CAPABILITY
      v
(:BusinessCapability)
      |
      | SUPPORTED_BY
      v
(:Application)
      |
      | USES
      v
(:Technology)
```

## Synthetic scenario

A fictitious organization called **Northstar Services** has three business capabilities supported by four applications and four technologies.

Expected graph:

- 1 Organization
- 3 BusinessCapability nodes
- 4 Application nodes
- 4 Technology nodes
- 3 HAS_CAPABILITY relationships
- 4 SUPPORTED_BY relationships
- 5 USES relationships

## Structure

```text
01-enterprise-architecture-knowledge-graph/
├── README.md
├── docker-compose.yml
├── model/
│   └── graph-model.md
├── cypher/
│   ├── 01-schema.cypher
│   ├── 02-data.cypher
│   ├── 03-queries.cypher
│   └── 04-validation.cypher
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

The script starts Neo4j, loads the synthetic graph, runs sample queries and validates the expected graph deterministically.

## Example query

```cypher
MATCH (c:BusinessCapability)-[:SUPPORTED_BY]->(a:Application)-[:USES]->(t:Technology)
WHERE a.criticality = 'HIGH'
RETURN c.name AS capability, a.name AS application, collect(t.name) AS technologies
LIMIT 10;
```

## Expected validation

```text
PASS organizations=1
PASS capabilities=3
PASS applications=4
PASS technologies=4
PASS has_capability=3
PASS supported_by=4
PASS uses=5
PASS required_keywords=MATCH,WHERE,RETURN,MERGE,SET,LIMIT
VALIDATION_RESULT=PASS
```

## What this proves

This artifact supports a **foundational** claim in:

- Neo4j property graphs;
- basic Cypher;
- simple graph modeling;
- reproducible technical experimentation.

It does not claim advanced Neo4j, GraphRAG, production knowledge graphs, clustering, performance engineering or production database operations.
