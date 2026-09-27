# Source-to-Target Mapping

## Rule

The source file layout does not define the graph model. Project questions define the target model; the import layer transforms source rows into that model.

## govtech_systems.csv

| Source field | Target |
| --- | --- |
| organization_id | PublicOrganization.id |
| organization_name | PublicOrganization.name |
| system_id | GovTechSystem.id |
| system_name | GovTechSystem.name |
| system_type | GovTechSystem.systemType |
| jurisdiction | GovTechSystem.jurisdiction |
| evidence_id | Evidence.id |
| evidence_title | Evidence.title |
| evidence_publisher | Evidence.publisher |
| evidence_url | Evidence.url |
| source_type | Evidence.sourceType |

Relationships created per row:

```text
(PublicOrganization)-[:RESPONSIBLE_FOR]->(GovTechSystem)
(GovTechSystem)-[:DOCUMENTED_BY]->(Evidence)
```

## system_capabilities.csv

| Source field | Target |
| --- | --- |
| system_id | resolves GovTechSystem.id |
| capability_id | Capability.id |
| capability_name | Capability.name |
| capability_domain | CapabilityDomain.name |

Relationships created per row:

```text
(GovTechSystem)-[:ENABLES]->(Capability)
(Capability)-[:IN_DOMAIN]->(CapabilityDomain)
```

## Type decisions

All identifiers remain strings because they are domain identifiers, not quantities. Human-readable names and URLs remain strings.

## Idempotence

Every canonical entity is loaded with `MERGE` on its stable identifier. Re-running the same CSV files must update/reconcile existing graph state rather than create duplicates.
