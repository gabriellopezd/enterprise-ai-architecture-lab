#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

export NEO4J_PASSWORD="${NEO4J_PASSWORD:-neo4j-local-pow}"
mkdir -p evidence
OUTPUT="evidence/runtime-validation.txt"
: > "$OUTPUT"

scalar() {
  local query="$1"
  docker compose exec -T neo4j cypher-shell --format plain -u neo4j -p "$NEO4J_PASSWORD" "$query" | tail -n 1 | tr -d '\r[:space:]'
}

assert_eq() {
  local name="$1"
  local actual="$2"
  local expected="$3"
  if [[ "$actual" != "$expected" ]]; then
    echo "FAIL $name=$actual expected=$expected" | tee -a "$OUTPUT"
    exit 1
  fi
  echo "PASS $name=$actual" | tee -a "$OUTPUT"
}

assert_eq organizations "$(scalar 'MATCH (n:Organization) RETURN count(n) AS count;')" 1
assert_eq capabilities "$(scalar 'MATCH (n:BusinessCapability) RETURN count(n) AS count;')" 3
assert_eq applications "$(scalar 'MATCH (n:Application) RETURN count(n) AS count;')" 4
assert_eq technologies "$(scalar 'MATCH (n:Technology) RETURN count(n) AS count;')" 4
assert_eq has_capability "$(scalar 'MATCH ()-[r:HAS_CAPABILITY]->() RETURN count(r) AS count;')" 3
assert_eq supported_by "$(scalar 'MATCH ()-[r:SUPPORTED_BY]->() RETURN count(r) AS count;')" 4
assert_eq uses "$(scalar 'MATCH ()-[r:USES]->() RETURN count(r) AS count;')" 5

all_cypher="$(cat cypher/*.cypher)"
for keyword in MATCH WHERE RETURN MERGE SET LIMIT; do
  if ! grep -Eq "\\b$keyword\\b" <<< "$all_cypher"; then
    echo "FAIL missing_keyword=$keyword" | tee -a "$OUTPUT"
    exit 1
  fi
done

echo "PASS required_keywords=MATCH,WHERE,RETURN,MERGE,SET,LIMIT" | tee -a "$OUTPUT"
echo "VALIDATION_RESULT=PASS" | tee -a "$OUTPUT"
