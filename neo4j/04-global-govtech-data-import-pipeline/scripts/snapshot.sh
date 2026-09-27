#!/usr/bin/env bash
set -euo pipefail

export NEO4J_PASSWORD="${NEO4J_PASSWORD:-neo4j-local-pow}"

scalar() {
  local query="$1"
  docker compose exec -T neo4j cypher-shell --format plain -u neo4j -p "$NEO4J_PASSWORD" "$query" | tail -n 1 | tr -d '\r[:space:]'
}

echo "organizations=$(scalar 'MATCH (n:PublicOrganization) RETURN count(n) AS count;')"
echo "systems=$(scalar 'MATCH (n:GovTechSystem) RETURN count(n) AS count;')"
echo "evidence=$(scalar 'MATCH (n:Evidence) RETURN count(n) AS count;')"
echo "capabilities=$(scalar 'MATCH (n:Capability) RETURN count(n) AS count;')"
echo "domains=$(scalar 'MATCH (n:CapabilityDomain) RETURN count(n) AS count;')"
echo "responsible_for=$(scalar 'MATCH ()-[r:RESPONSIBLE_FOR]->() RETURN count(r) AS count;')"
echo "documented_by=$(scalar 'MATCH ()-[r:DOCUMENTED_BY]->() RETURN count(r) AS count;')"
echo "enables=$(scalar 'MATCH ()-[r:ENABLES]->() RETURN count(r) AS count;')"
echo "in_domain=$(scalar 'MATCH ()-[r:IN_DOMAIN]->() RETURN count(r) AS count;')"
