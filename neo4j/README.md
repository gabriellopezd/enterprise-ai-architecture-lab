# Neo4j Evidence Track

This directory contains the public technical evidence produced through the Neo4j learning track. Milestone identity is defined by the immutable Proof-of-Work ID and commit, not only by a folder name.

| PoW | Learning milestone | Public path | Immutable commit | Status |
| --- | --- | --- | --- | --- |
| POW-NEO4J-001 | Neo4j Fundamentals | `neo4j/01-enterprise-architecture-knowledge-graph` | `c9a08859be1e83ea265ac1b6d4a0d2785e00bc53` | VERIFIED |
| POW-NEO4J-002 | Cypher Fundamentals | `neo4j/01-enterprise-architecture-knowledge-graph` | `994bb250380a9d2b5b278d45edba1f6aca621db5` | VERIFIED |
| POW-NEO4J-003 | Graph Data Modeling Fundamentals | `neo4j/03-global-govtech-graph-data-modeling` | `0a94ab182bdad4cd98841e72cd2296083a0bf9f4` | VERIFIED |
| POW-NEO4J-004 | Importing Data Fundamentals | `neo4j/04-global-govtech-data-import-pipeline` | `b9bd10706f61f2d5a9aa0854bde2c619dd71766f` | VERIFIED |
| POW-NEO4J-005 | Using Neo4j with Python | `neo4j/05-global-govtech-python-driver` | `683dcd995f291c59bec438bef7a07cd3df60ced2` | VERIFIED |
| POW-NEO4J-006 | Neo4j & GenerativeAI Fundamentals | `neo4j/06-global-govtech-graphrag-grounded-retrieval` | `b9fa1de8824d0e935e0cfa4e7969e91040677223` | VERIFIED |

## Historical path reuse

PoW #1 and PoW #2 intentionally remain distinct historical milestones even though both use `01-enterprise-architecture-knowledge-graph`. The immutable commits above preserve the boundary between the original Neo4j Fundamentals implementation and its later Cypher Fundamentals evolution. This history is not rewritten.

## Capability progression

```text
represent
  → operate
  → design / refactor
  → ingest
  → integrate
  → ground
```

Each milestone has its own claims boundary. Later milestones do not retroactively expand what earlier milestones proved.
