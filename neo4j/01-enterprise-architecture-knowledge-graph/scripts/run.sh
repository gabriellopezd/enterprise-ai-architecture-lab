#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

export NEO4J_PASSWORD="${NEO4J_PASSWORD:-neo4j-local-pow}"

echo "[PoW] Resetting Neo4j environment..."
docker compose down -v --remove-orphans >/dev/null 2>&1 || true
docker compose up -d

echo "[PoW] Waiting for Neo4j..."
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

echo "[PoW] Applying schema..."
docker compose exec -T neo4j cypher-shell -u neo4j -p "$NEO4J_PASSWORD" < cypher/01-schema.cypher

echo "[PoW] Loading curated public-source GovTech graph..."
docker compose exec -T neo4j cypher-shell -u neo4j -p "$NEO4J_PASSWORD" < cypher/02-data.cypher

echo "[PoW] Running sample queries..."
docker compose exec -T neo4j cypher-shell --format plain -u neo4j -p "$NEO4J_PASSWORD" < cypher/03-queries.cypher

echo "[PoW] Validating graph..."
./scripts/validate.sh
