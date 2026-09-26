# Graph Model

## Node labels

### Organization
Represents a fictitious organization.

Properties:
- `id`
- `name`
- `sector`

### BusinessCapability
Represents a generic organizational capability.

Properties:
- `id`
- `name`
- `maturity`

### Application
Represents a generic software application.

Properties:
- `id`
- `name`
- `criticality`

### Technology
Represents a generic technology used by an application.

Properties:
- `id`
- `name`
- `category`

## Relationships

```text
Organization -[:HAS_CAPABILITY]-> BusinessCapability
BusinessCapability -[:SUPPORTED_BY]-> Application
Application -[:USES]-> Technology
```

## Design rationale

The model is intentionally small. It is designed to demonstrate the mechanics of a property graph without exposing proprietary enterprise-architecture logic or product-specific concepts.
