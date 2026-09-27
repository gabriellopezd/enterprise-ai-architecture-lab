# Using Neo4j with Python — Proof of Work #5
## Global GovTech Python-to-Graph Application Layer

This public Proof of Work demonstrates a small but executable **Python application layer over Neo4j** using the official Neo4j Python Driver.

It extends the learning lineage from representing, querying, modeling and importing graph data into the next capability: **integrating Neo4j into application code with explicit connection lifecycle, parameterized Cypher, result transformation, managed transactions, graph/temporal/spatial driver types, and specific error handling**.

> **Public-safe boundary:** this artifact uses only public, official-source-backed information about globally known digital-government systems plus synthetic validation metadata. It does not represent ArquiFácil, AEther, Intellecto, MJD, an employer environment, customer data, private architecture, proprietary prompts, or confidential information.

## Course credential

- Neo4j GraphAcademy: **Using Neo4j with Python**
- Verification ID: `f9a98e30-6f22-4ff1-9bbd-38d406b77db8`
- Credential: https://graphacademy.neo4j.com/c/f9a98e30-6f22-4ff1-9bbd-38d406b77db8/

## Architecture question

> How should a Python application access a Neo4j knowledge layer safely and predictably, while keeping query data parameterized, read/write intent explicit, transaction boundaries controlled, and runtime behavior verifiable?

## Runtime architecture

~~~text
Python application
      |
      v
Neo4j Python Driver
      |
      +--> verify_connectivity()
      |
      +--> parameterized execute_query()
      |       |
      |       +--> READ routing
      |       +--> Result.to_df
      |
      +--> Session.execute_read()
      |
      +--> Session.execute_write()
              |
              +--> constraint-backed write
              +--> specific ConstraintError handling
      |
      v
Neo4j 5.26
~~~

## Public data used

The graph intentionally reuses the same public-safe GovTech examples established in PoW #4:

- GOV.UK One Login — Government Digital Service — https://docs.sign-in.service.gov.uk/
- Login.gov — U.S. General Services Administration — https://www.login.gov/about-us/
- Singpass — Government Technology Agency of Singapore — https://developer.singpass.gov.sg/
- X-Road — Nordic Institute for Interoperability Solutions — https://x-road.global/x-road-technology-overview

These records are curated learning inputs derived from official public documentation. They are not presented as authoritative registries or complete inventories.

## What is implemented

The executable application demonstrates:

- one reusable Neo4j `Driver` instance with explicit lifecycle management;
- `verify_connectivity()` before application operations;
- parameterized Cypher rather than string concatenation;
- `RoutingControl.READ` for read-only `execute_query()` calls;
- `Result.to_df` conversion into a pandas DataFrame;
- direct handling of Neo4j `Node` and `Relationship` objects;
- managed read transactions with `Session.execute_read()`;
- managed write transactions with `Session.execute_write()`;
- transaction-local result consumption;
- uniqueness constraints and specific `ConstraintError` handling;
- Neo4j temporal type round-trip and `.to_native()`;
- WGS-84 spatial type round-trip and destructuring;
- deterministic integration validation against a real Neo4j container.

## Automated validation

`scripts/run.sh` starts a fresh Neo4j 5.26 container and executes the Python integration validator.

The gate checks:

- driver connectivity;
- expected graph cardinalities: 4 systems, 7 capabilities and 10 `ENABLES` relationships;
- pandas result transformation for the Authentication capability;
- an untrusted parameter value is treated as data, returns no rows and leaves the graph intact;
- returned graph values expose expected node labels, properties and relationship type;
- `execute_read()` returns the expected systems;
- `execute_write()` creates a validation record;
- a duplicate validation ID is rejected by a uniqueness constraint and handled as `ConstraintError`;
- temporal values round-trip as `neo4j.time.DateTime` and convert to a native Python datetime;
- WGS-84 points round-trip as `neo4j.spatial.WGS84Point` and can be destructured;
- the run emits `VALIDATION_RESULT=PASS`.

Run locally:

~~~bash
python -m pip install -r requirements.txt
chmod +x scripts/run.sh
./scripts/run.sh
~~~

## Architectural learning

The core application boundary is:

~~~text
query structure
+ parameters
+ routing intent
+ transaction scope
+ result transformation
+ error contract
= controlled graph access layer
~~~

A database integration is not production-ready merely because a query returns data. The application must also control lifecycle, resource scope, transaction semantics, typed results, recoverable errors and validation.

## Claims boundary

This PoW supports a foundational claim in **Neo4j application integration with Python**: official driver lifecycle, parameterized Cypher, read routing, managed transactions, result transformation, driver data types, constraint-aware error handling and automated integration testing.

It does **not** claim production API engineering, asynchronous driver expertise, enterprise-scale connection-pool tuning, high-throughput transaction design, production observability, production security hardening, distributed-system resilience, or production deployment.

## Proof-of-work lineage

~~~text
PoW #1  represent
PoW #2  operate
PoW #3  design / refactor
PoW #4  ingest
PoW #5  integrate
~~~
