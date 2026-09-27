// Q1 — Public organizations and their documented relationship to GovTech systems
MATCH (o:PublicOrganization)-[r]->(s:GovTechSystem)
WHERE type(r) IN ['PROVIDES', 'OPERATES', 'POWERS', 'MAINTAINS']
RETURN o.name AS organization,
       type(r) AS role,
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

// Q4 — Trace systems to official evidence
MATCH (s:GovTechSystem)-[:DOCUMENTED_BY]->(e:Evidence)
RETURN s.name AS system,
       e.title AS source,
       e.publisher AS publisher,
       e.url AS url
ORDER BY system
LIMIT 10;

// Q5 — Trace X-Road to its maintaining organization and evidence
MATCH (o:PublicOrganization)-[:MAINTAINS]->(s:GovTechSystem)-[:DOCUMENTED_BY]->(e:Evidence)
WHERE s.name = 'X-Road'
RETURN o.name AS organization,
       s.name AS system,
       e.title AS source,
       e.url AS url
LIMIT 10;

// Q6 — Inspect Singpass capabilities
MATCH (s:GovTechSystem {name: 'Singpass'})-[:ENABLES]->(c:Capability)
RETURN s.name AS system,
       c.name AS capability,
       c.category AS category
ORDER BY capability
LIMIT 10;
