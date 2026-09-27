// Q1 — Public organizations and the GovTech systems they operate
MATCH (o:PublicOrganization)-[:OPERATES]->(s:GovTechSystem)
RETURN o.name AS organization,
       s.name AS system,
       s.jurisdiction AS jurisdiction
ORDER BY system
LIMIT 10;

// Q2 — Systems that enable authentication
MATCH (s:GovTechSystem)-[:ENABLES]->(c:Capability)
WHERE c.name = 'Authentication'
RETURN s.name AS system,
       s.jurisdiction AS jurisdiction
ORDER BY system
LIMIT 10;

// Q3 — Capabilities enabled by each GovTech system
MATCH (s:GovTechSystem)-[:ENABLES]->(c:Capability)
RETURN s.name AS system,
       collect(c.name) AS capabilities
ORDER BY system
LIMIT 10;

// Q4 — Trace operated systems to official evidence
MATCH (o:PublicOrganization)-[:OPERATES]->(s:GovTechSystem)-[:DOCUMENTED_BY]->(e:Evidence)
RETURN o.name AS organization,
       s.name AS system,
       e.title AS source,
       e.url AS url
ORDER BY system
LIMIT 10;

// Q5 — Trace the maintained interoperability layer to its evidence
MATCH (o:PublicOrganization)-[:MAINTAINS]->(s:GovTechSystem)-[:DOCUMENTED_BY]->(e:Evidence)
WHERE s.name = 'X-Road'
RETURN o.name AS organization,
       s.name AS system,
       e.title AS source,
       e.url AS url
LIMIT 10;

// Q6 — Inspect one real system and its capabilities
MATCH (s:GovTechSystem {name: 'Singpass'})-[:ENABLES]->(c:Capability)
RETURN s.name AS system,
       c.name AS capability,
       c.category AS category
ORDER BY capability
LIMIT 10;
