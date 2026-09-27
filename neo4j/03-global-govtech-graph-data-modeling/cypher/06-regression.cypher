// Existing broad use case — authentication systems
MATCH (s:GovTechSystem)-[:ENABLES]->(c:Capability {name: 'Authentication'})
RETURN s.name AS system ORDER BY system;

// Existing broad use case — capabilities by system
MATCH (s:GovTechSystem)-[:ENABLES]->(c:Capability)
RETURN s.name AS system, collect(c.name) AS capabilities
ORDER BY system;

// Existing provenance use case — systems to official evidence
MATCH (s:GovTechSystem)-[:DOCUMENTED_BY]->(e:Evidence)
RETURN s.name AS system, e.title AS source
ORDER BY system;

// Existing organization/evidence path for X-Road
MATCH (o:PublicOrganization)-[:MAINTAINS]->(s:GovTechSystem {name: 'X-Road'})-[:DOCUMENTED_BY]->(e:Evidence)
RETURN o.name AS organization, s.name AS system, e.title AS source;
