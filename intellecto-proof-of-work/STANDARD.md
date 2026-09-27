# INTELLECTO Proof-of-Work Standard v1.0

## Purpose

Create a repeatable portfolio format that turns verified learning and credentials into evidence-backed architectural artifacts without duplicating source evidence or overstating capability.

## Object model

```text
Learning Track
   ├── Course / Module learning
   ├── Technical Proofs of Work
   └── Credential
            │
            v
        IPOW Capstone
```

These are different objects:

- **Learning Track** — a bounded vendor/program journey. Course ordinals are local to the track.
- **Credential** — an issuer-backed certificate/certification. A professional credential is never invented as an extra course.
- **POW** — a technical evidence unit with an immutable identity and claims boundary.
- **IPOW** — a curated capstone that references existing evidence; it does not rewrite or duplicate it.

## Required capstone files

Each IPOW directory should contain at minimum:

```text
README.md
manifest.json
EVIDENCE-MAP.md
CLAIMS.md
```

Optional additions may include architecture diagrams, a live experience, screenshots, benchmark evidence or published articles when they add demonstrable value.

## Required manifest fields

- schema_version
- id
- title
- status
- owner
- brand
- credential_ref
- supporting_pow
- claims_boundary
- privacy
- live_experience
- article

Every supporting PoW entry must include its immutable evidence ID, public path and immutable commit when one exists.

## Verification rules

A capstone must not be marked `VERIFIED` unless:

1. its credential evidence is verified;
2. referenced PoWs exist and have stable identities;
3. immutable commit references are present for verified implementation evidence;
4. claims are no broader than the evidence;
5. private, employer, institutional and proprietary information is excluded;
6. repository validation passes;
7. the final capstone has been reviewed before publication.

## Cross-certification rule

A new certification pathway starts a **new learning track**. It does not continue the course numbering of a previous vendor pathway.

For example, a future Microsoft pathway must not become “Neo4j Course 7.” Its course/module numbering begins inside its own track, while global credential, PoW and IPOW IDs remain unique.

## Repository rule

Vendor/technology-specific implementation evidence belongs in its own technical area such as `neo4j/`. Cross-milestone capstones belong in `intellecto-proof-of-work/`.

Do not create a new repository for every certification. Repository extraction should happen only when an independent runtime, product, ownership or deployment boundary justifies it.

## Claims and ownership

Credentials belong to the person or entity named by the issuer. An IPOW may be published under the INTELLECTO evidence format without implying that INTELLECTO itself holds an individual's certification.

Public evidence must remain sanitized and provenance-aware.
