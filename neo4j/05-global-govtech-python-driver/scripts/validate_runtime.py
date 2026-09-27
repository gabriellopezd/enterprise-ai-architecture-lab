from __future__ import annotations

import os

from neo4j.spatial import WGS84Point
from neo4j.time import DateTime

from src.govtech_graph import GovTechGraphApp


def check(name: str, condition: bool, detail: str = "") -> None:
    if not condition:
        suffix = f" detail={detail}" if detail else ""
        print(f"FAIL {name}{suffix}")
        raise AssertionError(name)
    suffix = f" {detail}" if detail else ""
    print(f"PASS {name}{suffix}")


def main() -> int:
    uri = os.getenv("NEO4J_URI", "neo4j://localhost:7687")
    username = os.getenv("NEO4J_USERNAME", "neo4j")
    password = os.getenv("NEO4J_PASSWORD", "neo4j-local-pow")

    with GovTechGraphApp(uri, username, password) as app:
        check("driver_connectivity", True)

        app.reset_database()
        app.create_schema()
        app.seed_public_graph()

        counts = app.counts()
        check("system_count", counts["systems"] == 4, str(counts["systems"]))
        check("capability_count", counts["capabilities"] == 7, str(counts["capabilities"]))
        check("enables_count", counts["enables"] == 10, str(counts["enables"]))

        auth_df = app.find_systems_by_capability("Authentication")
        auth_ids = auth_df["system_id"].tolist()
        check(
            "dataframe_transformer",
            auth_ids == ["SYS-001", "SYS-002", "SYS-003"],
            str(auth_ids),
        )

        untrusted_value = "Authentication'UNTRUSTED"
        probe_df = app.find_systems_by_capability(untrusted_value)
        check("parameter_boundary_probe_empty", probe_df.empty)
        check("parameter_boundary_graph_intact", app.counts()["systems"] == 4)

        signature = app.graph_type_signature("SYS-001")
        check("node_type", "GovTechSystem" in signature["system_labels"])
        check("relationship_type", signature["relationship_type"] == "ENABLES")
        check("node_property_access", signature["system_id"] == "SYS-001")

        tx_rows = app.list_systems_with_read_transaction()
        check("execute_read_transaction", len(tx_rows) == 4, str(len(tx_rows)))

        first_write = app.create_validation_run("RUN-001", "SYS-004")
        duplicate_write = app.create_validation_run("RUN-001", "SYS-004")
        check("execute_write_transaction", first_write)
        check("constraint_error_handled", duplicate_write is False)
        check("constraint_preserves_single_write", app.validation_run_count() == 1)

        temporal = app.temporal_roundtrip()
        check("temporal_driver_type", isinstance(temporal, DateTime))
        native_temporal = temporal.to_native()
        check("temporal_to_native", native_temporal.tzinfo is not None)

        spatial = app.spatial_roundtrip()
        check("spatial_driver_type", isinstance(spatial, WGS84Point))
        longitude, latitude, height = spatial
        check(
            "spatial_destructuring",
            (longitude, latitude, height) == (10.0, 20.0, 30.0),
            str((longitude, latitude, height)),
        )

        print("VALIDATION_RESULT=PASS")
        return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:
        print(f"VALIDATION_RESULT=FAIL error={type(exc).__name__}: {exc}")
        raise
