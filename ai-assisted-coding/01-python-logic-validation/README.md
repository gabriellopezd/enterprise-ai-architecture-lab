# POW-AICODING-001 — AI-Assisted Python Logic & Validation

**Status:** AWAITING_CREDENTIAL  
**Learning context:** SENA — *Generación de códigos de software con inteligencia artificial* (3606124)  
**Evidence type:** sanitized implementation + deterministic validation  
**Public/private classification:** PUBLIC_SAFE_SYNTHETIC

## Problem

Generating code with an AI assistant is not sufficient evidence that the code is correct. The useful capability is the complete loop: express the problem clearly, obtain or refine code, inspect its logic, execute representative cases and preserve reproducible validation.

This PoW converts three small course exercises into a public-safe, testable Python artifact.

## Learning-to-evidence trace

| Learning concept | Public implementation evidence |
| --- | --- |
| Algorithm | Each program encodes a finite sequence of steps for a defined problem. |
| Variables | Inputs and calculated values are represented explicitly. |
| Control structures | `if` / `elif` / `else` select behavior from input conditions. |
| Functions | Core logic is isolated from CLI input/output so it can be reused and tested. |
| AI-assisted generation | The exercises originated in an AI-assisted coding learning context. |
| Human validation | Representative and boundary cases are checked deterministically. |

## Implemented scope

The artifact contains three small Python programs:

1. **Inventory:** determines whether stock requires replenishment.
2. **Grades:** classifies a score as *Excelente*, *Aprobado* or *No aprobado*.
3. **Discount:** applies a 10% discount when the purchase value reaches the defined threshold.

The public versions preserve the original exercise logic while refactoring the decision logic into functions so automated tests can validate it.

## Architecture

```text
problem / prompt
      │
      ▼
Python implementation
      │
      ├── inventory rule
      ├── grade classification
      └── discount rule
      │
      ▼
human-readable CLI
      │
      ▼
unit tests + CLI smoke tests
      │
      ▼
VALIDATION_RESULT=PASS
```

## Run locally

Requirements: Python 3.9+ and no third-party dependencies.

```bash
cd ai-assisted-coding/01-python-logic-validation
chmod +x scripts/validate.sh
./scripts/validate.sh
```

Expected final line:

```text
VALIDATION_RESULT=PASS
```

Persistent validation record: [evidence/ci-validation-2026-09-27.md](./evidence/ci-validation-2026-09-27.md).

## What the validation proves

The deterministic validation checks:

- Python syntax compilation;
- decision branches for all three programs;
- threshold/boundary behavior;
- the representative executions used during the learning exercise;
- CLI input/output behavior.

It therefore provides stronger technical evidence than screenshots alone.

## Architectural relevance

The milestone contributes foundational evidence in:

- algorithmic reasoning;
- basic Python control flow;
- AI-assisted software generation;
- human-in-the-loop verification;
- testability and reproducibility;
- evidence-based learning.

The reusable pattern is:

```text
prompt → generate/refine → inspect → execute → test → preserve → bound claims
```

## Credential relationship

The academic work has been submitted, but all instructor grading and the issuer-backed SENA credential are not yet complete. After the implementation is merged and CI passes, the PoW may be treated as implementation-complete while remaining `AWAITING_CREDENTIAL` until issuer evidence exists.

## Claims boundary

See [CLAIMS.md](./CLAIMS.md).

This PoW is foundational evidence. It does not establish professional Python software-engineering expertise, production AI coding-agent capability, autonomous code generation, secure SDLC maturity, production testing strategy, or production deployment competence.

## Privacy boundary

Only sanitized technical artifacts are public. Academic PDFs, the course video, Zajuna screenshots/records, grades beyond deliberately summarized status, and personal/issuer documents remain in private or canonical evidence layers.
