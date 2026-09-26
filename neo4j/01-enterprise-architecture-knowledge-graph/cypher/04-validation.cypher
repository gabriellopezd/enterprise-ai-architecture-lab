MATCH (n:Organization) RETURN count(n) AS organizations;
MATCH (n:BusinessCapability) RETURN count(n) AS capabilities;
MATCH (n:Application) RETURN count(n) AS applications;
MATCH (n:Technology) RETURN count(n) AS technologies;
MATCH ()-[r:HAS_CAPABILITY]->() RETURN count(r) AS has_capability;
MATCH ()-[r:SUPPORTED_BY]->() RETURN count(r) AS supported_by;
MATCH ()-[r:USES]->() RETURN count(r) AS uses;
