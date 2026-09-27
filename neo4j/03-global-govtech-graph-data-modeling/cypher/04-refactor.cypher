// REFACTOR A — promote repeated Capability.category values to canonical nodes
MATCH (c:Capability)
WHERE c.category IS NOT NULL
WITH c, c.category AS domainName
MERGE (d:CapabilityDomain {name: domainName})
MERGE (c)-[:IN_DOMAIN]->(d)
REMOVE c.category;

// REFACTOR B — introduce an intermediate context node for an evidence-backed
// system-to-capability assertion. Existing ENABLES and DOCUMENTED_BY edges remain.
MATCH (s:GovTechSystem)-[:ENABLES]->(c:Capability)
MATCH (s)-[:DOCUMENTED_BY]->(e:Evidence)
MERGE (a:CapabilityAssertion {id: s.id + '::' + c.id})
ON CREATE SET a.modelingPurpose = 'Evidence-backed capability claim'
MERGE (s)-[:HAS_CAPABILITY_CLAIM]->(a)
MERGE (a)-[:ASSERTS_CAPABILITY]->(c)
MERGE (a)-[:SUPPORTED_BY]->(e);
