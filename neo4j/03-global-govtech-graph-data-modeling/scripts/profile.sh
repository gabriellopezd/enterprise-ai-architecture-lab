#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

export NEO4J_PASSWORD="${NEO4J_PASSWORD:-neo4j-local-pow}"
mkdir -p evidence

mode="${1:-}"

case "$mode" in
  before)
    query="PROFILE MATCH (s:GovTechSystem)-[:ENABLES]->(c:Capability) WHERE c.category = 'Digital Identity' RETURN DISTINCT s.name AS system ORDER BY system;"
    output="evidence/profile-before.txt"
    ;;
  after)
    query="PROFILE MATCH (d:CapabilityDomain {name: 'Digital Identity'})<-[:IN_DOMAIN]-(c:Capability)<-[:ENABLES]-(s:GovTechSystem) RETURN DISTINCT s.name AS system ORDER BY system;"
    output="evidence/profile-after.txt"
    ;;
  *)
    echo "Usage: $0 before|after" >&2
    exit 2
    ;;
esac

docker compose exec -T neo4j cypher-shell --format verbose -u neo4j -p "$NEO4J_PASSWORD" "$query" | tee "$output"
