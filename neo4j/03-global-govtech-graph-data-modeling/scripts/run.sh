#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

export NEO4J_PASSWORD="${NEO4J_PASSWORD:-neo4j-local-pow}"

echo "[PoW #3] Resetting Neo4j environment..."
docker compose down -v --remove-orphans >/dev/null 2>&1 || true
docker compose up -d

echo "[PoW #3] Waiting for Neo4j..."
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

echo "[PoW #3] Applying schema..."
docker compose exec -T neo4j cypher-shell -u neo4j -p "$NEO4J_PASSWORD" < cypher/01-schema.cypher

echo "[PoW #3] Loading baseline GovTech model..."
docker compose exec -T neo4j cypher-shell -u neo4j -p "$NEO4J_PASSWORD" < cypher/02-baseline-data.cypher

echo "[PoW #3] Running baseline use cases..."
docker compose exec -T neo4j cypher-shell --format plain -u neo4j -p "$NEO4J_PASSWORD" < cypher/03-baseline-use-cases.cypher

echo "[PoW #3] Capturing baseline PROFILE..."
./scripts/profile.sh before

echo "[PoW #3] Applying justified refactors..."
docker compose exec -T neo4j cypher-shell -u neo4j -p "$NEO4J_PASSWORD" < cypher/04-refactor.cypher

echo "[PoW #3] Capturing refactored PROFILE..."
./scripts/profile.sh after

echo "[PoW #3] Running refactored use cases..."
docker compose exec -T neo4j cypher-shell --format plain -u neo4j -p "$NEO4J_PASSWORD" < cypher/05-refactored-use-cases.cypher

echo "[PoW #3] Running regression queries..."
docker compose exec -T neo4j cypher-shell --format plain -u neo4j -p "$NEO4J_PASSWORD" < cypher/06-regression.cypher

echo "[PoW #3] Validating model and evidence..."
./scripts/validate.sh
