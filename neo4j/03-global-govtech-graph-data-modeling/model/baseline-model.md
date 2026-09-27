# Baseline Model

The baseline reproduces the verified Cypher Fundamentals GovTech model at the start of PoW #3.

```text
PublicOrganization
        |
        | PROVIDES / OPERATES / POWERS / MAINTAINS
        v
GovTechSystem
        | ENABLES
        v
Capability { category }

GovTechSystem -[:DOCUMENTED_BY]-> Evidence
```

## Relevant properties

- `GovTechSystem`: `id`, `name`, `systemType`, `jurisdiction`
- `Capability`: `id`, `name`, `category`
- `Evidence`: `id`, `title`, `publisher`, `url`, `sourceType`, `retrievedOn`

## Modeling limitations under the new use cases

1. `Capability.category` repeats taxonomy values such as `Digital Identity` and `Interoperability`.
2. Category-focused queries start from capabilities and filter a property rather than traversing from a reusable domain entity.
3. A system may have many capabilities and one or more evidence sources, but the baseline does not make a specific capability assertion an addressable object.

These limitations did not make the earlier PoW incorrect. They became relevant only after new use cases were prioritized.
