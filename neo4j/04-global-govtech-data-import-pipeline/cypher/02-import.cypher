LOAD CSV WITH HEADERS FROM 'file:///govtech_systems.csv' AS row
WITH row
WHERE trim(row.system_id) <> ''
  AND trim(row.organization_id) <> ''
  AND trim(row.evidence_id) <> ''
MERGE (o:PublicOrganization {id: trim(row.organization_id)})
SET o.name = trim(row.organization_name)
MERGE (s:GovTechSystem {id: trim(row.system_id)})
SET s.name = trim(row.system_name),
    s.systemType = trim(row.system_type),
    s.jurisdiction = trim(row.jurisdiction)
MERGE (e:Evidence {id: trim(row.evidence_id)})
SET e.title = trim(row.evidence_title),
    e.publisher = trim(row.evidence_publisher),
    e.url = trim(row.evidence_url),
    e.sourceType = trim(row.source_type)
MERGE (o)-[:RESPONSIBLE_FOR]->(s)
MERGE (s)-[:DOCUMENTED_BY]->(e);

LOAD CSV WITH HEADERS FROM 'file:///system_capabilities.csv' AS row
WITH row
WHERE trim(row.system_id) <> ''
  AND trim(row.capability_id) <> ''
  AND trim(row.capability_domain) <> ''
MATCH (s:GovTechSystem {id: trim(row.system_id)})
MERGE (c:Capability {id: trim(row.capability_id)})
SET c.name = trim(row.capability_name)
MERGE (d:CapabilityDomain {name: trim(row.capability_domain)})
MERGE (s)-[:ENABLES]->(c)
MERGE (c)-[:IN_DOMAIN]->(d);
