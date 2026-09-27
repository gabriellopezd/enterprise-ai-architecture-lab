MATCH (n:PublicOrganization) RETURN count(n) AS organizations;
MATCH (n:GovTechSystem) RETURN count(n) AS systems;
MATCH (n:Capability) RETURN count(n) AS capabilities;
MATCH (n:Evidence) RETURN count(n) AS evidence;
MATCH ()-[r:OPERATES]->() RETURN count(r) AS operates;
MATCH ()-[r:MAINTAINS]->() RETURN count(r) AS maintains;
MATCH ()-[r:ENABLES]->() RETURN count(r) AS enables;
MATCH ()-[r:DOCUMENTED_BY]->() RETURN count(r) AS documented_by;
