from __future__ import annotations

from datetime import timezone
from typing import Any

from neo4j import GraphDatabase, Result, RoutingControl
from neo4j.exceptions import ConstraintError
from neo4j.spatial import WGS84Point
from neo4j.time import DateTime


SYSTEMS = [
    {
        "id": "SYS-001",
        "name": "GOV.UK One Login",
        "jurisdiction": "United Kingdom",
        "source_url": "https://docs.sign-in.service.gov.uk/",
    },
    {
        "id": "SYS-002",
        "name": "Login.gov",
        "jurisdiction": "United States",
        "source_url": "https://www.login.gov/about-us/",
    },
    {
        "id": "SYS-003",
        "name": "Singpass",
        "jurisdiction": "Singapore",
        "source_url": "https://developer.singpass.gov.sg/",
    },
    {
        "id": "SYS-004",
        "name": "X-Road",
        "jurisdiction": "Cross-border / international",
        "source_url": "https://x-road.global/x-road-technology-overview",
    },
]

CAPABILITIES = [
    {"id": "CAP-001", "name": "Authentication"},
    {"id": "CAP-002", "name": "Identity Verification"},
    {"id": "CAP-003", "name": "Digital Identity"},
    {"id": "CAP-004", "name": "Digital Signature"},
    {"id": "CAP-005", "name": "Consent-Based Data Sharing"},
    {"id": "CAP-006", "name": "Secure Data Exchange"},
    {"id": "CAP-007", "name": "Interoperability"},
]

ENABLES = [
    {"system_id": "SYS-001", "capability_id": "CAP-001"},
    {"system_id": "SYS-001", "capability_id": "CAP-002"},
    {"system_id": "SYS-002", "capability_id": "CAP-001"},
    {"system_id": "SYS-002", "capability_id": "CAP-002"},
    {"system_id": "SYS-003", "capability_id": "CAP-003"},
    {"system_id": "SYS-003", "capability_id": "CAP-001"},
    {"system_id": "SYS-003", "capability_id": "CAP-004"},
    {"system_id": "SYS-003", "capability_id": "CAP-005"},
    {"system_id": "SYS-004", "capability_id": "CAP-006"},
    {"system_id": "SYS-004", "capability_id": "CAP-007"},
]


class GovTechGraphApp:
    """Small public-safe Neo4j application layer used by PoW #5."""

    def __init__(self, uri: str, username: str, password: str, database: str = "neo4j"):
        self.database = database
        self.driver = GraphDatabase.driver(uri, auth=(username, password))

    def __enter__(self) -> "GovTechGraphApp":
        self.verify_connectivity()
        return self

    def __exit__(self, exc_type: Any, exc: Any, traceback: Any) -> None:
        self.close()

    def verify_connectivity(self) -> None:
        self.driver.verify_connectivity()

    def close(self) -> None:
        self.driver.close()

    def reset_database(self) -> None:
        self.driver.execute_query(
            "MATCH (n) DETACH DELETE n",
            database_=self.database,
        )

    def create_schema(self) -> None:
        statements = [
            "CREATE CONSTRAINT govtech_system_id IF NOT EXISTS "
            "FOR (s:GovTechSystem) REQUIRE s.id IS UNIQUE",
            "CREATE CONSTRAINT capability_id IF NOT EXISTS "
            "FOR (c:Capability) REQUIRE c.id IS UNIQUE",
            "CREATE CONSTRAINT validation_run_id IF NOT EXISTS "
            "FOR (v:ValidationRun) REQUIRE v.id IS UNIQUE",
        ]
        for statement in statements:
            self.driver.execute_query(statement, database_=self.database)

    @staticmethod
    def _seed_tx(tx, systems, capabilities, enables) -> None:
        tx.run(
            """
            UNWIND $systems AS row
            MERGE (s:GovTechSystem {id: row.id})
            SET s.name = row.name,
                s.jurisdiction = row.jurisdiction,
                s.sourceUrl = row.source_url
            """,
            systems=systems,
        ).consume()

        tx.run(
            """
            UNWIND $capabilities AS row
            MERGE (c:Capability {id: row.id})
            SET c.name = row.name
            """,
            capabilities=capabilities,
        ).consume()

        tx.run(
            """
            UNWIND $enables AS row
            MATCH (s:GovTechSystem {id: row.system_id})
            MATCH (c:Capability {id: row.capability_id})
            MERGE (s)-[:ENABLES]->(c)
            """,
            enables=enables,
        ).consume()

    def seed_public_graph(self) -> None:
        with self.driver.session(database=self.database) as session:
            session.execute_write(
                self._seed_tx,
                systems=SYSTEMS,
                capabilities=CAPABILITIES,
                enables=ENABLES,
            )

    def find_systems_by_capability(self, capability: str):
        query = """
        MATCH (s:GovTechSystem)-[:ENABLES]->(c:Capability {name: $capability})
        RETURN s.id AS system_id,
               s.name AS system_name,
               s.jurisdiction AS jurisdiction
        ORDER BY system_id
        """
        return self.driver.execute_query(
            query,
            capability=capability,
            database_=self.database,
            routing_=RoutingControl.READ,
            result_transformer_=Result.to_df,
        )

    @staticmethod
    def _list_systems_tx(tx):
        result = tx.run(
            """
            MATCH (s:GovTechSystem)
            RETURN s.id AS id, s.name AS name
            ORDER BY id
            """
        )
        return [record.data() for record in result]

    def list_systems_with_read_transaction(self):
        with self.driver.session(database=self.database) as session:
            return session.execute_read(self._list_systems_tx)

    def graph_type_signature(self, system_id: str) -> dict[str, Any]:
        records, _, _ = self.driver.execute_query(
            """
            MATCH (s:GovTechSystem {id: $system_id})-[r:ENABLES]->(c:Capability)
            RETURN s, r, c
            ORDER BY c.id
            LIMIT 1
            """,
            system_id=system_id,
            database_=self.database,
            routing_=RoutingControl.READ,
        )
        record = records[0]
        system = record["s"]
        relationship = record["r"]
        capability = record["c"]
        return {
            "system_id": system["id"],
            "system_labels": sorted(system.labels),
            "relationship_type": relationship.type,
            "capability_id": capability["id"],
        }

    @staticmethod
    def _create_validation_run_tx(tx, run_id: str, system_id: str) -> None:
        tx.run(
            """
            MATCH (s:GovTechSystem {id: $system_id})
            CREATE (v:ValidationRun {
                id: $run_id,
                createdAt: datetime()
            })-[:CHECKED]->(s)
            """,
            run_id=run_id,
            system_id=system_id,
        ).consume()

    def create_validation_run(self, run_id: str, system_id: str) -> bool:
        try:
            with self.driver.session(database=self.database) as session:
                session.execute_write(
                    self._create_validation_run_tx,
                    run_id=run_id,
                    system_id=system_id,
                )
            return True
        except ConstraintError:
            return False

    def counts(self) -> dict[str, int]:
        records, _, _ = self.driver.execute_query(
            """
            MATCH (s:GovTechSystem)
            WITH count(s) AS systems
            MATCH (c:Capability)
            WITH systems, count(c) AS capabilities
            MATCH ()-[r:ENABLES]->()
            RETURN systems, capabilities, count(r) AS enables
            """,
            database_=self.database,
            routing_=RoutingControl.READ,
        )
        return dict(records[0])

    def validation_run_count(self) -> int:
        records, _, _ = self.driver.execute_query(
            "MATCH (v:ValidationRun) RETURN count(v) AS count",
            database_=self.database,
            routing_=RoutingControl.READ,
        )
        return records[0]["count"]

    def temporal_roundtrip(self):
        value = DateTime(2026, 9, 27, 12, 0, 0, tzinfo=timezone.utc)
        records, _, _ = self.driver.execute_query(
            "RETURN $value AS value",
            value=value,
            database_=self.database,
            routing_=RoutingControl.READ,
        )
        return records[0]["value"]

    def spatial_roundtrip(self):
        value = WGS84Point((10.0, 20.0, 30.0))
        records, _, _ = self.driver.execute_query(
            "RETURN $value AS value",
            value=value,
            database_=self.database,
            routing_=RoutingControl.READ,
        )
        return records[0]["value"]
