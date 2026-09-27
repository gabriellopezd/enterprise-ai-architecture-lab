# CI Validation — 2026-09-27

## Final successful runtime validation

- Workflow: **Neo4j Importing Data PoW**
- Run ID: `36348131374`
- Result: **SUCCESS**
- Runtime validator: `VALIDATION_RESULT=PASS`
- Uploaded artifact ID: `10940823098`

Validated assertions:

```text
PASS organizations=4
PASS systems=4
PASS evidence=4
PASS capabilities=7
PASS capability_domains=4
PASS responsible_for=4
PASS documented_by=4
PASS enables=10
PASS in_domain=7
PASS duplicate_organizations=0
PASS duplicate_systems=0
PASS duplicate_evidence=0
PASS duplicate_capabilities=0
PASS missing_required_ids=0
PASS singpass_signature=1
PASS xroad_interoperability=1
PASS official_evidence_urls=4
PASS idempotent_rerun=true
VALIDATION_RESULT=PASS
```

The pipeline executed two identical imports and compared graph snapshots. The second import preserved the same canonical node and relationship cardinalities, providing direct evidence of idempotent re-run behavior.

## Troubleshooting evidence

The first CI attempt failed because the Neo4j container tried to change ownership of a read-only bind-mounted import directory. The compose configuration was corrected so Neo4j could initialize the import directory, after which the complete pipeline passed.

This troubleshooting note is retained because import pipelines depend on target/runtime configuration as well as correct source-to-target mappings.
