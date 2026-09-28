# Enterprise AI Architecture Lab

Public evidence laboratory focused on building verifiable capability toward the professional profile of an **Enterprise AI Architect / Digital Transformation Architect**.

The repository is intentionally organized around evidence, not course completion badges. Technical learning, credentials and portfolio capstones are different objects with different claim boundaries.

## Repository architecture

```text
enterprise-ai-architecture-lab/
├── neo4j/
│   ├── README.md
│   ├── 01-enterprise-architecture-knowledge-graph/
│   ├── 03-global-govtech-graph-data-modeling/
│   ├── 04-global-govtech-data-import-pipeline/
│   ├── 05-global-govtech-python-driver/
│   └── 06-global-govtech-graphrag-grounded-retrieval/
├── docker/
│   ├── README.md
│   └── 01-reproducible-containerized-application/
├── ai-assisted-coding/
│   ├── README.md
│   └── 01-python-logic-validation/
├── intellecto-proof-of-work/
│   ├── README.md
│   ├── STANDARD.md
│   └── 001-neo4j-certified-professional/
├── scripts/
└── .github/workflows/
```

Technology/vendor-specific implementation evidence belongs in its technical area. Cross-milestone portfolio capstones belong in `intellecto-proof-of-work/`.

A new certification pathway does **not** continue the course numbering of a previous vendor pathway.

## Professional focus

This lab develops evidence across:

- Enterprise Architecture
- Digital Transformation
- Artificial Intelligence
- Data & Knowledge Architecture
- Cloud & Platform Architecture
- Application & Integration Architecture
- Security, Risk & Governance
- DevSecOps & Platform Engineering
- Business Capability Mapping
- Technology Strategy
- Operating Model Transformation
- Architecture Decision-Making
- Evidence-Based Delivery
- GovTech and Digital Public Infrastructure

Not every Proof of Work implements every domain. Each artifact must separate **implemented scope**, **architectural relevance**, **future extension** and **claims boundary**.

## Evidence model

```text
Learning Track
      ↓
Technical learning
      ↓
Focused Proofs of Work
      ↓
Runtime / deterministic validation
      ↓
Issuer credential
      ↓
Curated IPOW capstone
      ↓
Career / portfolio / content reuse
```

A credential is issuer-backed evidence. A PoW is implementation evidence. An IPOW composes existing evidence without rewriting it.

## Neo4j track

The Neo4j track currently contains six verified learning milestones.

| PoW | Milestone | Capability progression | Status |
| --- | --- | --- | --- |
| POW-NEO4J-001 | Neo4j Fundamentals | represent | VERIFIED |
| POW-NEO4J-002 | Cypher Fundamentals | operate | VERIFIED |
| POW-NEO4J-003 | Graph Data Modeling Fundamentals | design / refactor | VERIFIED |
| POW-NEO4J-004 | Importing Data Fundamentals | ingest | VERIFIED |
| POW-NEO4J-005 | Using Neo4j with Python | integrate | VERIFIED |
| POW-NEO4J-006 | Neo4j & GenerativeAI Fundamentals | ground | VERIFIED |

See [neo4j/README.md](./neo4j/README.md) for immutable paths and commits.

PoW #1 and PoW #2 share a historical public path but remain distinct through immutable commit identities. The repository preserves that history instead of rewriting it.

## Docker track

The Docker evidence track starts with a focused SENA learning milestone:

| PoW | Milestone | Capability progression | Status |
| --- | --- | --- | --- |
| POW-DOCKER-001 | Reproducible Containerized Application | build → run → validate → modify → rebuild → revalidate | AWAITING_CREDENTIAL |

See [docker/README.md](./docker/README.md).

The public implementation is designed to be reproducible and independently validated. The associated SENA credential remains pending and is not claimed as verified until issuer evidence exists.

## AI-assisted coding track

This SENA learning milestone focuses on the controlled loop from problem/prompt to code, human review, execution and deterministic validation.

| PoW | Milestone | Capability progression | Status |
| --- | --- | --- | --- |
| POW-AICODING-001 | AI-Assisted Python Logic & Validation | understand → generate/refine → inspect → execute → test → preserve | IMPLEMENTATION_IN_PROGRESS |

See [ai-assisted-coding/README.md](./ai-assisted-coding/README.md).

The public artifact is a sanitized, testable refactoring of small learning exercises. Academic submissions and platform records remain private.

## INTELLECTO Proof of Work

The capstone layer follows the reusable [INTELLECTO Proof-of-Work Standard](./intellecto-proof-of-work/STANDARD.md).

Current capstone:

- **IPOW-001 — Neo4j Certified Professional** — `BUILD_PENDING`

It references the six verified Neo4j PoWs and the separately governed credential evidence. It is not a seventh course and does not duplicate the underlying code.

## Public / private boundary

This repository contains only:

- public-safe architectural patterns;
- public official-source evidence or synthetic data where needed;
- intentionally selected technical Proofs of Work;
- credential references safe for public portfolio use;
- claims proportional to available evidence.

It does not contain proprietary product architectures, internal metamodels, confidential business logic, customer information, employer or institutional internals, secrets or private datasets.

## Validation

Repository-level validation includes:

- milestone-specific runtime or deterministic validation where applicable;
- immutable evidence references;
- explicit claims/privacy boundaries;
- IPOW manifest validation through GitHub Actions.

Static documentation alone is not treated as proof of runtime behavior.

## Progression

Future evidence may extend into cloud, AI transformation, agentic architectures, interoperability, security, governance, platform architecture and other relevant capability areas.

Those are progression directions, not claims of current implementation.
