# POW-DOCKER-001 — Reproducible Containerized Application

**Status:** AWAITING_CREDENTIAL  
**Learning context:** SENA — *Despliegue de aplicaciones y servicios en contenedores Docker*  
**Evidence type:** deterministic implementation + runtime validation  
**Public/private classification:** PUBLIC_SAFE_SYNTHETIC

## Problem

A course exercise can show that a container ran once, but that alone is weak professional evidence. This PoW converts the learning milestone into a small, reproducible artifact whose build, runtime and expected response can be independently validated.

## Architecture

```text
src/index.html
      │
      ▼
  Dockerfile
      │ docker build
      ▼
 container image
      │ docker run
      ▼
 Nginx container
      │
 host :18080 / :8080
      │
      ▼
 HTTP validation
      │
      ▼
 expected content
```

## Implemented scope

The artifact implements:

1. an `nginx:alpine`-based image;
2. deterministic source packaging through a Dockerfile;
3. explicit service exposure on container port 80;
4. container execution with host-to-container port mapping;
5. runtime verification with `docker ps`;
6. HTTP verification with `curl`;
7. expected-content validation;
8. source modification followed by rebuild and revalidation;
9. automatic cleanup of the validation container.

The final source represents the second validated application version produced after the baseline was modified and rebuilt.

## Run locally

From this directory:

```bash
chmod +x scripts/validate.sh
./scripts/validate.sh
```

Expected terminal outcome:

```text
IMAGE_BUILD=PASS
CONTAINER_START=PASS
CONTAINER_RUNNING=PASS
HTTP_RESPONSE=PASS
EXPECTED_CONTENT=PASS

VALIDATION_RESULT=PASS
```

## What the validation proves

The script checks behavior rather than relying on static screenshots:

- the image can be rebuilt from source;
- the container starts successfully;
- the container remains running;
- the mapped HTTP endpoint responds;
- the served application contains the expected updated content.

## Architectural relevance

This milestone contributes evidence toward:

- Cloud & Platform Architecture foundations;
- DevOps / Platform Engineering foundations;
- reproducible delivery;
- runtime verification;
- immutable technical evidence.

It also reinforces the evidence pattern used elsewhere in this lab:

```text
learn → build → validate → preserve evidence → bound claims
```

## Credential relationship

The technical implementation is already reproducible, but the associated SENA learning credential has not yet been issued and verified. Therefore this PoW remains `AWAITING_CREDENTIAL` and must not be represented as fully verified credential-backed evidence.

## Claims boundary

See [CLAIMS.md](./CLAIMS.md).

In short, this is foundational containerization evidence. It does not claim production container orchestration, Kubernetes, cloud production operations, enterprise-scale platform engineering, production security hardening or production observability.

## Privacy boundary

The repository contains only the sanitized technical artifact. Academic submissions, Zajuna records, personal evidence files and issuer documents are intentionally excluded.
