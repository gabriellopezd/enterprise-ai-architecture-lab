#!/usr/bin/env bash
set -euo pipefail

IMAGE="pow-docker-001:validation"
CONTAINER="pow-docker-001-validation"
PORT="18080"
EXPECTED="Contenedor Docker actualizado correctamente"

cleanup() {
  docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
}

trap cleanup EXIT

echo "=== POW-DOCKER-001 VALIDATION ==="

echo "[1/5] Building image..."
docker build -t "$IMAGE" . >/dev/null
echo "IMAGE_BUILD=PASS"

echo "[2/5] Starting container..."
cleanup
docker run -d \
  --name "$CONTAINER" \
  -p "127.0.0.1:${PORT}:80" \
  "$IMAGE" >/dev/null
echo "CONTAINER_START=PASS"

echo "[3/5] Checking runtime..."
for i in {1..20}; do
  if curl -fsS "http://localhost:${PORT}" >/tmp/pow-docker-001.html 2>/dev/null; then
    break
  fi
  sleep 1
done

docker ps --filter "name=${CONTAINER}" --filter "status=running" \
  --format '{{.Names}}' | grep -qx "$CONTAINER"
echo "CONTAINER_RUNNING=PASS"

echo "[4/5] Checking HTTP response..."
curl -fsS "http://localhost:${PORT}" >/tmp/pow-docker-001.html
echo "HTTP_RESPONSE=PASS"

echo "[5/5] Checking expected application content..."
grep -Fq "$EXPECTED" /tmp/pow-docker-001.html
echo "EXPECTED_CONTENT=PASS"

echo
echo "VALIDATION_RESULT=PASS"
