// PUBLIC ORGANIZATIONS
MERGE (gds:PublicOrganization {id: 'ORG-001'})
SET gds.name = 'Government Digital Service', gds.jurisdiction = 'United Kingdom';
MERGE (gsa:PublicOrganization {id: 'ORG-002'})
SET gsa.name = 'U.S. General Services Administration', gsa.jurisdiction = 'United States';
MERGE (govtech:PublicOrganization {id: 'ORG-003'})
SET govtech.name = 'Government Technology Agency of Singapore', govtech.jurisdiction = 'Singapore';
MERGE (niis:PublicOrganization {id: 'ORG-004'})
SET niis.name = 'Nordic Institute for Interoperability Solutions', niis.jurisdiction = 'Cross-border / international';

// GOVTECH SYSTEMS
MERGE (oneLogin:GovTechSystem {id: 'SYS-001'})
SET oneLogin.name = 'GOV.UK One Login', oneLogin.systemType = 'Government sign-in and identity service', oneLogin.jurisdiction = 'United Kingdom';
MERGE (loginGov:GovTechSystem {id: 'SYS-002'})
SET loginGov.name = 'Login.gov', loginGov.systemType = 'Government sign-in and identity service', loginGov.jurisdiction = 'United States';
MERGE (singpass:GovTechSystem {id: 'SYS-003'})
SET singpass.name = 'Singpass', singpass.systemType = 'National digital identity', singpass.jurisdiction = 'Singapore';
MERGE (xroad:GovTechSystem {id: 'SYS-004'})
SET xroad.name = 'X-Road', xroad.systemType = 'Distributed data exchange layer', xroad.jurisdiction = 'Cross-border / international';

// CAPABILITIES — category is intentionally duplicated in the baseline
MERGE (authentication:Capability {id: 'CAP-001'})
SET authentication.name = 'Authentication', authentication.category = 'Digital Identity';
MERGE (identityVerification:Capability {id: 'CAP-002'})
SET identityVerification.name = 'Identity Verification', identityVerification.category = 'Digital Identity';
MERGE (digitalIdentity:Capability {id: 'CAP-003'})
SET digitalIdentity.name = 'Digital Identity', digitalIdentity.category = 'Digital Identity';
MERGE (digitalSignature:Capability {id: 'CAP-004'})
SET digitalSignature.name = 'Digital Signature', digitalSignature.category = 'Digital Trust';
MERGE (consentData:Capability {id: 'CAP-005'})
SET consentData.name = 'Consent-Based Data Sharing', consentData.category = 'Data Exchange';
MERGE (secureExchange:Capability {id: 'CAP-006'})
SET secureExchange.name = 'Secure Data Exchange', secureExchange.category = 'Interoperability';
MERGE (interoperability:Capability {id: 'CAP-007'})
SET interoperability.name = 'Interoperability', interoperability.category = 'Interoperability';

// OFFICIAL EVIDENCE
MERGE (e1:Evidence {id: 'EVID-001'})
SET e1.title = 'GOV.UK One Login Technical Documentation', e1.publisher = 'Government Digital Service', e1.url = 'https://docs.sign-in.service.gov.uk/', e1.sourceType = 'Official documentation', e1.retrievedOn = '2026-09-27';
MERGE (e2:Evidence {id: 'EVID-002'})
SET e2.title = 'Login.gov — About Us', e2.publisher = 'Login.gov / U.S. General Services Administration', e2.url = 'https://www.login.gov/about-us/', e2.sourceType = 'Official website', e2.retrievedOn = '2026-09-27';
MERGE (e3:Evidence {id: 'EVID-003'})
SET e3.title = 'Singpass Developer Portal', e3.publisher = 'Government Technology Agency of Singapore', e3.url = 'https://developer.singpass.gov.sg/', e3.sourceType = 'Official developer documentation', e3.retrievedOn = '2026-09-27';
MERGE (e4:Evidence {id: 'EVID-004'})
SET e4.title = 'X-Road Technology Overview', e4.publisher = 'X-Road / Nordic Institute for Interoperability Solutions', e4.url = 'https://x-road.global/x-road-technology-overview', e4.sourceType = 'Official product documentation', e4.retrievedOn = '2026-09-27';

// ORGANIZATION → SYSTEM
MATCH (gds:PublicOrganization {id: 'ORG-001'}), (oneLogin:GovTechSystem {id: 'SYS-001'}) MERGE (gds)-[:PROVIDES]->(oneLogin);
MATCH (gsa:PublicOrganization {id: 'ORG-002'}), (loginGov:GovTechSystem {id: 'SYS-002'}) MERGE (gsa)-[:OPERATES]->(loginGov);
MATCH (govtech:PublicOrganization {id: 'ORG-003'}), (singpass:GovTechSystem {id: 'SYS-003'}) MERGE (govtech)-[:POWERS]->(singpass);
MATCH (niis:PublicOrganization {id: 'ORG-004'}), (xroad:GovTechSystem {id: 'SYS-004'}) MERGE (niis)-[:MAINTAINS]->(xroad);

// SYSTEM → CAPABILITY
MATCH (s:GovTechSystem {id: 'SYS-001'}), (a:Capability {id: 'CAP-001'}), (v:Capability {id: 'CAP-002'}) MERGE (s)-[:ENABLES]->(a) MERGE (s)-[:ENABLES]->(v);
MATCH (s:GovTechSystem {id: 'SYS-002'}), (a:Capability {id: 'CAP-001'}), (v:Capability {id: 'CAP-002'}) MERGE (s)-[:ENABLES]->(a) MERGE (s)-[:ENABLES]->(v);
MATCH (s:GovTechSystem {id: 'SYS-003'}), (d:Capability {id: 'CAP-003'}), (a:Capability {id: 'CAP-001'}), (sig:Capability {id: 'CAP-004'}), (data:Capability {id: 'CAP-005'}) MERGE (s)-[:ENABLES]->(d) MERGE (s)-[:ENABLES]->(a) MERGE (s)-[:ENABLES]->(sig) MERGE (s)-[:ENABLES]->(data);
MATCH (s:GovTechSystem {id: 'SYS-004'}), (secure:Capability {id: 'CAP-006'}), (interop:Capability {id: 'CAP-007'}) MERGE (s)-[:ENABLES]->(secure) MERGE (s)-[:ENABLES]->(interop);

// SYSTEM → EVIDENCE
MATCH (s:GovTechSystem {id: 'SYS-001'}), (e:Evidence {id: 'EVID-001'}) MERGE (s)-[:DOCUMENTED_BY]->(e);
MATCH (s:GovTechSystem {id: 'SYS-002'}), (e:Evidence {id: 'EVID-002'}) MERGE (s)-[:DOCUMENTED_BY]->(e);
MATCH (s:GovTechSystem {id: 'SYS-003'}), (e:Evidence {id: 'EVID-003'}) MERGE (s)-[:DOCUMENTED_BY]->(e);
MATCH (s:GovTechSystem {id: 'SYS-004'}), (e:Evidence {id: 'EVID-004'}) MERGE (s)-[:DOCUMENTED_BY]->(e);
