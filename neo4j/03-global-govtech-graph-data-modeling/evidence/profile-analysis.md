# PROFILE Analysis — Runtime Evidence

Workflow run: `36341554797` (first PoW #3 runtime validation).

## Baseline query

```cypher
PROFILE
MATCH (s:GovTechSystem)-[:ENABLES]->(c:Capability)
WHERE c.category = 'Digital Identity'
RETURN DISTINCT s.name AS system
ORDER BY system;
```

Observed plan evidence:
- starts with `NodeByLabelScan` on `Capability`;
- scans 7 Capability rows;
- filters `c.category = 'Digital Identity'` down to 3 rows;
- total database accesses: **36**;
- total allocated memory: **1816**.

## Refactored query

```cypher
PROFILE
MATCH (d:CapabilityDomain {name: 'Digital Identity'})
      <-[:IN_DOMAIN]-(c:Capability)
      <-[:ENABLES]-(s:GovTechSystem)
RETURN DISTINCT s.name AS system
ORDER BY system;
```

Observed plan evidence:
- starts with `NodeUniqueIndexSeek` on the uniqueness-constrained `CapabilityDomain.name`;
- the start anchor is 1 domain row rather than a label scan across all Capability nodes;
- total database accesses: **39**;
- total allocated memory: **1848**.

## Architectural interpretation

The refactor **improves the semantic and selective starting point** for domain-centric queries, but it did **not** reduce total database accesses or memory on this tiny instance. In fact, accesses moved from 36 to 39 because the refactored model adds traversal through `CapabilityDomain`.

This is important evidence, not a failure:

- the model is more reusable and expressive for the prioritized use case;
- the uniqueness constraint gives an indexed anchor;
- the additional relationship traversal has a runtime cost;
- this dataset is too small to support any performance-improvement claim;
- a performance decision at scale would require representative cardinalities and workload testing.

Therefore PoW #3 intentionally claims **use-case-driven model fitness and observable runtime reasoning**, not a benchmark win.

## Runtime artifacts

CI generates and uploads:
- `profile-before.txt`
- `profile-after.txt`
- `runtime-validation.txt`

The full execution plans remain available as workflow evidence.
