// Q1 — Capabilities and supporting applications
MATCH (c:BusinessCapability)-[:SUPPORTED_BY]->(a:Application)
RETURN c.name AS capability, a.name AS application, a.criticality AS criticality
ORDER BY capability, application
LIMIT 10;

// Q2 — Filter high-criticality applications
MATCH (c:BusinessCapability)-[:SUPPORTED_BY]->(a:Application)
WHERE a.criticality = 'HIGH'
RETURN c.name AS capability, a.name AS application
ORDER BY capability, application
LIMIT 10;

// Q3 — Traverse capability → application → technology
MATCH (c:BusinessCapability)-[:SUPPORTED_BY]->(a:Application)-[:USES]->(t:Technology)
RETURN c.name AS capability,
       a.name AS application,
       collect(t.name) AS technologies
ORDER BY capability, application
LIMIT 10;

// Q4 — Trace from organization to technology
MATCH (o:Organization)-[:HAS_CAPABILITY]->(c:BusinessCapability)
      -[:SUPPORTED_BY]->(a:Application)-[:USES]->(t:Technology)
WHERE o.id = 'ORG-001'
RETURN o.name AS organization,
       c.name AS capability,
       a.name AS application,
       t.name AS technology
ORDER BY capability, application, technology
LIMIT 20;

// Q5 — MERGE + SET update example
MERGE (t:Technology {id: 'TECH-003'})
SET t.learning_note = 'Used in Neo4j Fundamentals PoW'
RETURN t.name AS technology, t.learning_note AS note;
