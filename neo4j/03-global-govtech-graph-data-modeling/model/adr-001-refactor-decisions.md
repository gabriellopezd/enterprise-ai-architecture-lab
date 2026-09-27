# ADR-001 — Graph Data Modeling Refactor Decisions

**Status:** Accepted for PoW #3

## Context

Graph Data Modeling Fundamentals teaches that models should evolve only when use cases or runtime evidence justify change. This PoW therefore evaluates candidate patterns rather than implementing every technique.

## Decision A — CapabilityDomain node: ACCEPT

Reason:
- category values repeat across capabilities;
- UC-01 needs domain-centric traversal;
- canonical domain nodes provide reusable identity and a selective query anchor;
- a uniqueness constraint gives the runtime a stable indexed start point.

Migration:
`Capability.category` → `(:Capability)-[:IN_DOMAIN]->(:CapabilityDomain)` → remove old property.

## Decision B — CapabilityAssertion intermediate node: ACCEPT

Reason:
- UC-02 requires a specific system/capability/evidence context;
- binary `ENABLES` and `DOCUMENTED_BY` edges do not explicitly bind evidence to one capability assertion;
- the assertion needs identity and can later carry provenance metadata without overloading a binary relationship.

## Decision C — IdentitySystem derived label: REJECT

Reason:
- identity-related semantics are already derivable from capability relationships;
- no prioritized use case or PROFILE evidence requires a secondary label;
- materializing the label would create synchronization obligations without demonstrated value.

## Decision D — Specialized relationship types: REJECT

Examples considered: `ENABLES_DIGITAL_IDENTITY`, `ENABLES_INTEROPERABILITY`.

Reason:
- no high-volume recurring query currently justifies schema proliferation;
- generic `ENABLES` plus canonical domain traversal is sufficient;
- specialized types remain a future optimization option if runtime evidence changes.

## Decision E — Jurisdiction node: DEFER

Reason:
- current use cases only return jurisdiction as descriptive data;
- no prioritized question requires traversal between systems, organizations and jurisdictions;
- therefore the property remains appropriate for this milestone.

## Consequence

The refactored model is richer where use cases require it and deliberately unchanged where they do not. This preserves the course principle: **model for questions, not for theoretical completeness**.
