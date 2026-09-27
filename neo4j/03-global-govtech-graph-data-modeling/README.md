# Graph Data Modeling Fundamentals — Proof of Work #3
## Global GovTech Model Refactoring

This public Proof of Work demonstrates **use-case-driven graph data modeling and refactoring** in Neo4j using a small, evidence-backed set of real public digital-government systems.

It builds on the learning lineage of PoW #1 (Neo4j Fundamentals) and PoW #2 (Cypher Fundamentals), but uses a **distinct milestone directory** so its identity and claim boundary remain immutable.

> **Public-safe boundary:** only public information from official sources is used. This artifact does not represent ArquiFácil, AEther, Intellecto, MJD, an employer architecture, a private institutional environment, customer data, proprietary product logic or a private metamodel.

## Architecture question

> How should a small GovTech knowledge graph evolve when new use cases require reusable capability domains, exact evidence lineage for capability claims, and measurable query behavior?

## Prioritized use cases

1. Which GovTech systems enable capabilities in a particular capability domain?
2. What official evidence supports a specific system-to-capability claim?
3. Can existing broad system/capability/evidence queries still return the same business answers after refactoring?

## Baseline model

```text
(:PublicOrganization)-[:PROVIDES|OPERATES|POWERS|MAINTAINS]->(:GovTechSystem)
(:GovTechSystem)-[:ENABLES]->(:Capability {category: ...})
(:GovTechSystem)-[:DOCUMENTED_BY]->(:Evidence)
```

Two limitations are intentionally evaluated:

- `Capability.category` repeats a taxonomy value on multiple capability nodes and requires filtering capability properties.
- `GovTechSystem -> Evidence` does not explicitly bind a particular source to a particular `ENABLES` claim.

## Adopted refactors

### 1. Canonical capability domains

`Capability.category` is promoted into shared `CapabilityDomain` nodes:

```text
(:Capability)-[:IN_DOMAIN]->(:CapabilityDomain)
```

The old `category` property is removed after migration. This follows the course pattern: repeated property → canonical node → explicit relationship → rewrite affected query → retest.

### 2. Intermediate node for evidence-backed capability claims

An intermediate `CapabilityAssertion` node makes a system/capability/evidence context explicit:

```text
(:GovTechSystem)-[:HAS_CAPABILITY_CLAIM]->(:CapabilityAssertion)
(:CapabilityAssertion)-[:ASSERTS_CAPABILITY]->(:Capability)
(:CapabilityAssertion)-[:SUPPORTED_BY]->(:Evidence)
```

The original generic `ENABLES` and `DOCUMENTED_BY` relationships remain because existing broad use cases still depend on them.

## Patterns evaluated but not adopted

- **Derived labels such as `IdentitySystem`:** rejected because the same semantics are already derivable from capability relationships and no measured runtime need justifies consistency debt.
- **Specialized relationships such as `ENABLES_DIGITAL_IDENTITY`:** rejected because the dataset and use cases do not justify relationship-type proliferation.
- **Jurisdiction as a node:** deferred because current prioritized use cases only display jurisdiction; they do not require jurisdiction traversal or shared jurisdiction semantics.

This is deliberate: the goal is not to force every course technique into one graph, but to show architectural judgment.

## Runtime evidence

The build captures `PROFILE` plans before and after the capability-domain refactor:

- `evidence/profile-before.txt` — property-filter baseline.
- `evidence/profile-after.txt` — relationship-based query starting from the canonical domain.

The graph is intentionally small, so the PoW does not claim enterprise-scale performance gains. The evidence demonstrates how to inspect runtime behavior and search-space selectivity rather than extrapolating unsupported benchmarks.

## Validation gate

PoW #3 is verified only when:

- the refactor executes from a clean Neo4j instance;
- regression tests preserve expected business answers;
- canonicalization and assertion counts pass;
- PROFILE evidence is captured;
- CI returns `VALIDATION_RESULT=PASS`;
- the reviewed branch is merged to `main`.

## Professional capability signal

This artifact demonstrates a repeatable modeling method:

```text
Prioritized use case
      ↓
Baseline model
      ↓
Observed limitation
      ↓
Refactor decision
      ↓
Migration Cypher
      ↓
Rewritten queries
      ↓
Regression tests + PROFILE
      ↓
Evidence-backed acceptance
```

## Claims boundary

This PoW supports a foundational claim in Neo4j graph data modeling, model refactoring, canonicalization, intermediate-node modeling, regression testing and runtime-plan inspection.

It does **not** claim production knowledge-graph architecture, production GraphRAG, AI-agent production readiness, enterprise-scale performance engineering, or authoritative architecture of the public systems modeled.
