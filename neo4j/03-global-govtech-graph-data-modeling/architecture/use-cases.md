# Prioritized Use Cases

Graph modeling decisions in this PoW are driven by questions, not by a desire to add more labels, nodes or relationship types.

## UC-01 — Systems by capability domain

**Question:** Which GovTech systems enable capabilities in the `Digital Identity` domain?

Why it matters:
- capability domains are reusable analytical groupings;
- the baseline stores the domain as a repeated property on `Capability` nodes;
- the query must filter capability properties before returning systems.

Expected systems:
- GOV.UK One Login
- Login.gov
- Singpass

## UC-02 — Exact evidence for a capability claim

**Question:** What official evidence supports the claim that Singpass enables Digital Signature?

Baseline limitation:

The baseline graph separately says:

```text
Singpass -[:ENABLES]-> Digital Signature
Singpass -[:DOCUMENTED_BY]-> Singpass Developer Portal
```

but it has no first-class object representing the specific assertion **Singpass enables Digital Signature supported by this evidence**.

Expected refactored answer:
- system: Singpass
- capability: Digital Signature
- evidence: Singpass Developer Portal

## UC-03 — Preserve broad queries

Existing use cases from the Cypher Fundamentals milestone must continue to work:

- systems that enable Authentication;
- capabilities enabled by each system;
- systems traced to official evidence;
- X-Road traced to its maintaining organization and evidence.

These are semantic regression tests.

## Decision rule

A candidate refactor is accepted only if it improves model fitness for a prioritized use case and preserves required existing answers. Runtime behavior is inspected with `PROFILE`, but no large-scale performance claim is made from this small graph.
