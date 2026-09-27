# Refactored Model

## Canonical capability domain

```text
GovTechSystem -[:ENABLES]-> Capability -[:IN_DOMAIN]-> CapabilityDomain
```

`CapabilityDomain` is an educational modeling taxonomy introduced by this PoW. It is **not** claimed to be an official taxonomy of the public systems or organizations.

## Evidence-backed capability assertion

```text
GovTechSystem
   |
   | HAS_CAPABILITY_CLAIM
   v
CapabilityAssertion
   | ASSERTS_CAPABILITY
   +---------------------> Capability
   | SUPPORTED_BY
   +---------------------> Evidence
```

`CapabilityAssertion` is an intermediate/context node. It exists because the context involves three first-class entities — system, capability and evidence — and the assertion itself needs a stable identity.

## Relationships retained

`ENABLES` and `DOCUMENTED_BY` remain in the model for broad queries and backwards-compatible semantic use cases.

## Consistency obligation

The assertion layer is derived from existing `ENABLES` + `DOCUMENTED_BY` facts. If those source facts change in a future version, the assertion layer must be reconciled. Materialized semantics improve expressiveness but create consistency debt.
