// Organization
MERGE (o:Organization {id: 'ORG-001'})
SET o.name = 'Northstar Services',
    o.sector = 'Fictitious Services';

// Business capabilities
MERGE (c1:BusinessCapability {id: 'CAP-001'})
SET c1.name = 'Customer Service',
    c1.maturity = 'DEFINED';

MERGE (c2:BusinessCapability {id: 'CAP-002'})
SET c2.name = 'Data Analytics',
    c2.maturity = 'MANAGED';

MERGE (c3:BusinessCapability {id: 'CAP-003'})
SET c3.name = 'Case Management',
    c3.maturity = 'DEFINED';

// Applications
MERGE (a1:Application {id: 'APP-001'})
SET a1.name = 'Service Portal',
    a1.criticality = 'HIGH';

MERGE (a2:Application {id: 'APP-002'})
SET a2.name = 'Analytics Hub',
    a2.criticality = 'MEDIUM';

MERGE (a3:Application {id: 'APP-003'})
SET a3.name = 'Case Tracker',
    a3.criticality = 'HIGH';

MERGE (a4:Application {id: 'APP-004'})
SET a4.name = 'Integration Gateway',
    a4.criticality = 'HIGH';

// Technologies
MERGE (t1:Technology {id: 'TECH-001'})
SET t1.name = 'PostgreSQL',
    t1.category = 'Database';

MERGE (t2:Technology {id: 'TECH-002'})
SET t2.name = 'Node.js',
    t2.category = 'Runtime';

MERGE (t3:Technology {id: 'TECH-003'})
SET t3.name = 'Neo4j',
    t3.category = 'Graph Database';

MERGE (t4:Technology {id: 'TECH-004'})
SET t4.name = 'Docker',
    t4.category = 'Container';

// Organization → capabilities
MATCH (o:Organization {id: 'ORG-001'})
MATCH (c:BusinessCapability)
MERGE (o)-[:HAS_CAPABILITY]->(c);

// Capabilities → applications
MATCH (c1:BusinessCapability {id: 'CAP-001'}), (a1:Application {id: 'APP-001'})
MERGE (c1)-[:SUPPORTED_BY]->(a1);

MATCH (c2:BusinessCapability {id: 'CAP-002'}), (a2:Application {id: 'APP-002'})
MERGE (c2)-[:SUPPORTED_BY]->(a2);

MATCH (c3:BusinessCapability {id: 'CAP-003'}), (a3:Application {id: 'APP-003'}), (a4:Application {id: 'APP-004'})
MERGE (c3)-[:SUPPORTED_BY]->(a3)
MERGE (c3)-[:SUPPORTED_BY]->(a4);

// Applications → technologies
MATCH (a1:Application {id: 'APP-001'}), (t1:Technology {id: 'TECH-001'}), (t2:Technology {id: 'TECH-002'})
MERGE (a1)-[:USES]->(t1)
MERGE (a1)-[:USES]->(t2);

MATCH (a2:Application {id: 'APP-002'}), (t3:Technology {id: 'TECH-003'})
MERGE (a2)-[:USES]->(t3);

MATCH (a3:Application {id: 'APP-003'}), (t1:Technology {id: 'TECH-001'})
MERGE (a3)-[:USES]->(t1);

MATCH (a4:Application {id: 'APP-004'}), (t4:Technology {id: 'TECH-004'})
MERGE (a4)-[:USES]->(t4);
