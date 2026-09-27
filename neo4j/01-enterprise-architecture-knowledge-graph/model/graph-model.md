# Graph Model — Global GovTech Systems

## Purpose

Represent a small set of real public digital systems, the organizations responsible for them, the capabilities they provide and the official evidence used to support the model.

The model is intentionally small because this is a **Cypher Fundamentals** Proof of Work.

## Node labels

### PublicOrganization

Represents a real public-sector organization.

Properties:
- `id`
- `name`
- `jurisdiction`

### GovTechSystem

Represents a real digital government system, service or interoperability layer.

Properties:
- `id`
- `name`
- `systemType`
- `jurisdiction`

### Capability

Represents a generic, reusable digital-government capability.

Properties:
- `id`
- `name`
- `category`

### Evidence

Represents an official public source used to support the modeled system and capability claims.

Properties:
- `id`
- `title`
- `publisher`
- `url`
- `sourceType`
- `retrievedOn`

## Relationships

```text
PublicOrganization -[:OPERATES]-> GovTechSystem
PublicOrganization -[:MAINTAINS]-> GovTechSystem
GovTechSystem -[:ENABLES]-> Capability
GovTechSystem -[:DOCUMENTED_BY]-> Evidence
```

## Current graph

```text
Government Digital Service
  └─ OPERATES → GOV.UK One Login
                  ├─ ENABLES → Authentication
                  ├─ ENABLES → Identity Verification
                  └─ DOCUMENTED_BY → GOV.UK One Login Technical Documentation

U.S. General Services Administration
  └─ OPERATES → Login.gov
                  ├─ ENABLES → Authentication
                  ├─ ENABLES → Identity Verification
                  └─ DOCUMENTED_BY → Login.gov About Us

Government Technology Agency of Singapore
  └─ OPERATES → Singpass
                  ├─ ENABLES → Digital Identity
                  ├─ ENABLES → Authentication
                  ├─ ENABLES → Digital Signature
                  ├─ ENABLES → Consent-Based Data Sharing
                  └─ DOCUMENTED_BY → Singpass Developer Portal

Nordic Institute for Interoperability Solutions
  └─ MAINTAINS → X-Road
                   ├─ ENABLES → Secure Data Exchange
                   ├─ ENABLES → Interoperability
                   └─ DOCUMENTED_BY → X-Road Technology Overview
```

## Design rationale

- `GovTechSystem` is intentionally generic enough to represent an identity service, government platform or data-exchange layer without pretending they are equivalent products.
- Capabilities are modeled as reusable nodes so multiple systems can point to the same capability.
- Evidence is modeled explicitly so the public PoW can show provenance rather than unsupported claims.
- The model does not reproduce the internal architecture of any of the systems.
- No private, proprietary, employer, customer or institution-specific data is used.
