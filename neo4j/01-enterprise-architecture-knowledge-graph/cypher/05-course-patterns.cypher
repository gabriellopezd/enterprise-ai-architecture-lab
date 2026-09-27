// Reference-only Cypher Fundamentals patterns.
// This file is not executed by scripts/run.sh.
// It records course concepts without mutating the public evidence graph.

// ON CREATE / ON MATCH
MERGE (x:LearningExample {id: 'TEMP-001'})
ON CREATE SET x.createdAt = datetime()
ON MATCH SET x.updatedAt = datetime()
RETURN x;

// SET and REMOVE
MATCH (x:LearningExample {id: 'TEMP-001'})
SET x.note = 'Temporary learning property'
REMOVE x.note
RETURN x;

// DELETE a node without relationships
MATCH (x:LearningExample {id: 'TEMP-001'})
DELETE x;

// DETACH DELETE when relationships may exist
MERGE (a:LearningExample {id: 'TEMP-A'})
MERGE (b:LearningExample {id: 'TEMP-B'})
MERGE (a)-[:TEMP_RELATIONSHIP]->(b);

MATCH (a:LearningExample {id: 'TEMP-A'})
DETACH DELETE a;

MATCH (b:LearningExample {id: 'TEMP-B'})
DELETE b;
