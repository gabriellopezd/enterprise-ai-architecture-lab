MATCH (n) RETURN labels(n) AS labels, count(*) AS count ORDER BY labels;
MATCH ()-[r]->() RETURN type(r) AS relationshipType, count(*) AS count ORDER BY relationshipType;
MATCH (s:GovTechSystem {name:'Singpass'})-[:ENABLES]->(c:Capability {name:'Digital Signature'})
RETURN s.name AS system, c.name AS capability;
