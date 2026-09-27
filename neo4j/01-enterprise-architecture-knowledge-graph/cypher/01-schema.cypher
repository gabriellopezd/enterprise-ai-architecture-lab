CREATE CONSTRAINT public_organization_id_unique IF NOT EXISTS
FOR (n:PublicOrganization)
REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT govtech_system_id_unique IF NOT EXISTS
FOR (n:GovTechSystem)
REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT capability_id_unique IF NOT EXISTS
FOR (n:Capability)
REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT evidence_id_unique IF NOT EXISTS
FOR (n:Evidence)
REQUIRE n.id IS UNIQUE;
