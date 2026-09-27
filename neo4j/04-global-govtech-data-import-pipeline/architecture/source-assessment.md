# Source Assessment

## Source purpose

The source layer is a small, curated CSV representation of public GovTech facts already supported by official primary sources.

## Assessment dimensions

### Format and structure
- Format: UTF-8 CSV with headers.
- Structure: deliberately denormalized enough to demonstrate transformation.
- `govtech_systems.csv` repeats organization/system/evidence context on each row.
- `system_capabilities.csv` repeats system IDs and domain values across capability rows.

### Frequency
- This PoW models a **batch snapshot**, not a real-time feed.
- Re-running the same snapshot must converge without duplicates.
- Incremental or event-driven updates are outside the evidence boundary.

### Data quality
- **Accuracy:** public claims are limited to facts represented in official primary sources.
- **Validity:** fields are selected because they support the target GovTech graph use cases.
- **Completeness:** required IDs and relationship endpoints are present for every modeled row.
- **Reliability:** provenance points to official public publishers.
- **Consistency:** identifier formats and relationship mappings are deterministic across files.

### Identity
Canonical identities are explicit:
- Organization: `organization_id`
- System: `system_id`
- Evidence: `evidence_id`
- Capability: `capability_id`
- Capability domain: normalized `capability_domain` string

## Known limitations

- The dataset is intentionally tiny and curated.
- It is not an authoritative registry of GovTech systems.
- It does not prove performance at scale.
- It does not implement automated source refresh, CDC, streaming, or entity resolution across conflicting sources.
