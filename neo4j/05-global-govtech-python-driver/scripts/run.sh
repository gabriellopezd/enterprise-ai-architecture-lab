#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

export NEO4J_PASSWORD="${NEO4J_PASSWORD:-neo4j-local-pow}"
export NEO4J_URI="${NEO4J_URI:-neo4j://localhost:7687}"
export NEO4J_USERNAME="${NEO4J_USERNAME:-neo4j}"
export PYTHONPATH="$ROOT"

mkdir -p evidence

echo "[PoW #5] Resetting Neo4j environment..."
docker compose down -v --remove-orphans >/dev/null 2>&1 || true
docker compose up -d

echo "[PoW #5] Waiting for Neo4j..."
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

echo "[PoW #5] Running Python + Neo4j integration validation..."
python scripts/validate_runtime.py | tee evidence/runtime-validation.txt
