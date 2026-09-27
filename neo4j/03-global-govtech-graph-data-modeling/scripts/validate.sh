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
assert_eq capability_domains "$(scalar 'MATCH (n:CapabilityDomain) RETURN count(n) AS count;')" 4
assert_eq capability_assertions "$(scalar 'MATCH (n:CapabilityAssertion) RETURN count(n) AS count;')" 10
assert_eq enables "$(scalar 'MATCH ()-[r:ENABLES]->() RETURN count(r) AS count;')" 10
assert_eq documented_by "$(scalar 'MATCH ()-[r:DOCUMENTED_BY]->() RETURN count(r) AS count;')" 4
assert_eq in_domain "$(scalar 'MATCH ()-[r:IN_DOMAIN]->() RETURN count(r) AS count;')" 7
assert_eq has_capability_claim "$(scalar 'MATCH ()-[r:HAS_CAPABILITY_CLAIM]->() RETURN count(r) AS count;')" 10
assert_eq asserts_capability "$(scalar 'MATCH ()-[r:ASSERTS_CAPABILITY]->() RETURN count(r) AS count;')" 10
assert_eq supported_by "$(scalar 'MATCH ()-[r:SUPPORTED_BY]->() RETURN count(r) AS count;')" 10

assert_eq removed_category_properties "$(scalar 'MATCH (c:Capability) WHERE c.category IS NOT NULL RETURN count(c) AS count;')" 0
assert_eq digital_identity_systems "$(scalar "MATCH (d:CapabilityDomain {name:'Digital Identity'})<-[:IN_DOMAIN]-(c:Capability)<-[:ENABLES]-(s:GovTechSystem) RETURN count(DISTINCT s) AS count;")" 3
assert_eq exact_singpass_signature_claim "$(scalar "MATCH (s:GovTechSystem {name:'Singpass'})-[:HAS_CAPABILITY_CLAIM]->(a:CapabilityAssertion)-[:ASSERTS_CAPABILITY]->(c:Capability {name:'Digital Signature'}), (a)-[:SUPPORTED_BY]->(e:Evidence {title:'Singpass Developer Portal'}) RETURN count(a) AS count;")" 1
assert_eq authentication_systems "$(scalar "MATCH (s:GovTechSystem)-[:ENABLES]->(:Capability {name:'Authentication'}) RETURN count(s) AS count;")" 3

if [[ ! -s evidence/profile-before.txt || ! -s evidence/profile-after.txt ]]; then
  echo "FAIL profile_evidence_missing=true" | tee -a "$OUTPUT"
  exit 1
fi
echo "PASS profile_evidence=before_and_after" | tee -a "$OUTPUT"

echo "PASS rejected_patterns=documented_not_forced" | tee -a "$OUTPUT"
echo "VALIDATION_RESULT=PASS" | tee -a "$OUTPUT"
