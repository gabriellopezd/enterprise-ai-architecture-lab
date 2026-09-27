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
assert_eq evidence "$(scalar 'MATCH (n:Evidence) RETURN count(n) AS count;')" 4
assert_eq capabilities "$(scalar 'MATCH (n:Capability) RETURN count(n) AS count;')" 7
assert_eq capability_domains "$(scalar 'MATCH (n:CapabilityDomain) RETURN count(n) AS count;')" 4

assert_eq responsible_for "$(scalar 'MATCH ()-[r:RESPONSIBLE_FOR]->() RETURN count(r) AS count;')" 4
assert_eq documented_by "$(scalar 'MATCH ()-[r:DOCUMENTED_BY]->() RETURN count(r) AS count;')" 4
assert_eq enables "$(scalar 'MATCH ()-[r:ENABLES]->() RETURN count(r) AS count;')" 10
assert_eq in_domain "$(scalar 'MATCH ()-[r:IN_DOMAIN]->() RETURN count(r) AS count;')" 7

assert_eq duplicate_organizations "$(scalar 'MATCH (n:PublicOrganization) WITH n.id AS id, count(*) AS c WHERE c > 1 RETURN count(*) AS count;')" 0
assert_eq duplicate_systems "$(scalar 'MATCH (n:GovTechSystem) WITH n.id AS id, count(*) AS c WHERE c > 1 RETURN count(*) AS count;')" 0
assert_eq duplicate_evidence "$(scalar 'MATCH (n:Evidence) WITH n.id AS id, count(*) AS c WHERE c > 1 RETURN count(*) AS count;')" 0
assert_eq duplicate_capabilities "$(scalar 'MATCH (n:Capability) WITH n.id AS id, count(*) AS c WHERE c > 1 RETURN count(*) AS count;')" 0
assert_eq missing_required_ids "$(scalar 'MATCH (n) WHERE (n:PublicOrganization OR n:GovTechSystem OR n:Evidence OR n:Capability) AND n.id IS NULL RETURN count(n) AS count;')" 0

assert_eq singpass_signature "$(scalar "MATCH (:GovTechSystem {id:'SYS-003'})-[:ENABLES]->(:Capability {id:'CAP-004'}) RETURN count(*) AS count;")" 1
assert_eq xroad_interoperability "$(scalar "MATCH (:GovTechSystem {id:'SYS-004'})-[:ENABLES]->(:Capability {id:'CAP-007'}) RETURN count(*) AS count;")" 1
assert_eq official_evidence_urls "$(scalar "MATCH (e:Evidence) WHERE e.url STARTS WITH 'https://' RETURN count(e) AS count;")" 4

if ! diff -q evidence/snapshot-first.txt evidence/snapshot-second.txt >/dev/null; then
  echo "FAIL idempotent_rerun=false" | tee -a "$OUTPUT"
  exit 1
fi
echo "PASS idempotent_rerun=true" | tee -a "$OUTPUT"

echo "VALIDATION_RESULT=PASS" | tee -a "$OUTPUT"
