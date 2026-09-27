// UC-01 REFACTORED — start from a canonical indexed domain node
MATCH (d:CapabilityDomain {name: 'Digital Identity'})<-[:IN_DOMAIN]-(c:Capability)<-[:ENABLES]-(s:GovTechSystem)
RETURN DISTINCT s.name AS system
ORDER BY system;

// UC-02 REFACTORED — exact system/capability/evidence context
MATCH (s:GovTechSystem {name: 'Singpass'})-[:HAS_CAPABILITY_CLAIM]->(a:CapabilityAssertion)-[:ASSERTS_CAPABILITY]->(c:Capability {name: 'Digital Signature'}),
      (a)-[:SUPPORTED_BY]->(e:Evidence)
RETURN s.name AS system, c.name AS capability, e.title AS evidence;

// Domain inventory
MATCH (d:CapabilityDomain)<-[:IN_DOMAIN]-(c:Capability)
RETURN d.name AS domain, collect(c.name) AS capabilities
ORDER BY domain;
