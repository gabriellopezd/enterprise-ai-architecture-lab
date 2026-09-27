// UC-01 BASELINE — systems by repeated capability.category property
MATCH (s:GovTechSystem)-[:ENABLES]->(c:Capability)
WHERE c.category = 'Digital Identity'
RETURN DISTINCT s.name AS system
ORDER BY system;

// UC-02 BASELINE — this returns a source next to a capability but the model
// does not contain a first-class object binding the evidence to this exact claim.
MATCH (s:GovTechSystem {name: 'Singpass'})-[:ENABLES]->(c:Capability {name: 'Digital Signature'}),
      (s)-[:DOCUMENTED_BY]->(e:Evidence)
RETURN s.name AS system, c.name AS capability, e.title AS evidence;
