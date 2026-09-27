#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

export NEO4J_PASSWORD="${NEO4J_PASSWORD:-neo4j-local-pow}"

echo "[PoW #4] Resetting Neo4j environment..."
docker compose down -v --remove-orphans >/dev/null 2>&1 || true
docker compose up -d

echo "[PoW #4] Waiting for Neo4j..."
ready=0
for _ in $(seq 1 60); do
  if docker compose exec -T neo4j cypher-shell -u neo4j -p "$NEO4J_PASSWORD" "RETURN 1;" >/dev/null 2>&1; then
    ready=1
    break
  fi
  sleep 2
done

if [[ "$ready" -ne 1 ]]; then
  echo "Neo4j did not become ready in time." >&2
  docker compose logs neo4j >&2 || true
  exit 1
fi

echo "[PoW #4] Applying schema..."
docker compose exec -T neo4j cypher-shell -u neo4j -p "$NEO4J_PASSWORD" < cypher/01-schema.cypher

echo "[PoW #4] First import..."
docker compose exec -T neo4j cypher-shell -u neo4j -p "$NEO4J_PASSWORD" < cypher/02-import.cypher
./scripts/snapshot.sh > evidence/snapshot-first.txt

echo "[PoW #4] Second identical import..."
docker compose exec -T neo4j cypher-shell -u neo4j -p "$NEO4J_PASSWORD" < cypher/02-import.cypher
./scripts/snapshot.sh > evidence/snapshot-second.txt

if ! diff -u evidence/snapshot-first.txt evidence/snapshot-second.txt > evidence/idempotence-diff.txt; then
  echo "Idempotence snapshot changed after identical re-import." >&2
  cat evidence/idempotence-diff.txt >&2
  exit 1
fi

echo "[PoW #4] Validating graph..."
./scripts/validate.sh
