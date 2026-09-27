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

assert_eq organizations "$(scalar 'MATCH (n:PublicOrganization) RETURN count(n) AS count;')" 4
assert_eq systems "$(scalar 'MATCH (n:GovTechSystem) RETURN count(n) AS count;')" 4
assert_eq capabilities "$(scalar 'MATCH (n:Capability) RETURN count(n) AS count;')" 7
assert_eq evidence "$(scalar 'MATCH (n:Evidence) RETURN count(n) AS count;')" 4
assert_eq operates "$(scalar 'MATCH ()-[r:OPERATES]->() RETURN count(r) AS count;')" 3
assert_eq maintains "$(scalar 'MATCH ()-[r:MAINTAINS]->() RETURN count(r) AS count;')" 1
assert_eq enables "$(scalar 'MATCH ()-[r:ENABLES]->() RETURN count(r) AS count;')" 10
assert_eq documented_by "$(scalar 'MATCH ()-[r:DOCUMENTED_BY]->() RETURN count(r) AS count;')" 4

all_cypher="$(cat cypher/*.cypher)"
for keyword in MATCH WHERE RETURN MERGE SET REMOVE DELETE LIMIT; do
  if ! grep -Eq "\\b$keyword\\b" <<< "$all_cypher"; then
    echo "FAIL missing_keyword=$keyword" | tee -a "$OUTPUT"
    exit 1
  fi
done

for pattern in "DETACH DELETE" "ON CREATE" "ON MATCH"; do
  if ! grep -Fq "$pattern" <<< "$all_cypher"; then
    echo "FAIL missing_pattern=$pattern" | tee -a "$OUTPUT"
    exit 1
  fi
done

echo "PASS required_patterns=MATCH,WHERE,RETURN,MERGE,SET,REMOVE,DELETE,DETACH DELETE,ON CREATE,ON MATCH,LIMIT" | tee -a "$OUTPUT"
echo "VALIDATION_RESULT=PASS" | tee -a "$OUTPUT"
