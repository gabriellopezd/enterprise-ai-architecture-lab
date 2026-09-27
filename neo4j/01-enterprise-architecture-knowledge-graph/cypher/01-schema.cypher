CREATE CONSTRAINT organization_id_unique IF NOT EXISTS
FOR (n:Organization)
REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT capability_id_unique IF NOT EXISTS
FOR (n:BusinessCapability)
REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT application_id_unique IF NOT EXISTS
FOR (n:Application)
REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT technology_id_unique IF NOT EXISTS
FOR (n:Technology)
REQUIRE n.id IS UNIQUE;
