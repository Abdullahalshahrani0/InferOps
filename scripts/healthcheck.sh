#!/usr/bin/env bash
# InferOps health check: service, port, API, model.
# Exit 0 = healthy, 1 = unhealthy.
set -euo pipefail

SERVICE="inferops-model"
URL="http://127.0.0.1:11434"
MODEL="${MODEL:-qwen2.5:0.5b}"
FAILED=0

ok()   { echo "[ OK ] $1"; }
fail() { echo "[FAIL] $1"; FAILED=1; }

if systemctl is-active --quiet "$SERVICE"; then
  ok "service $SERVICE is active"
else
  fail "service $SERVICE is not active"
fi

if ss -tln | grep -q "127.0.0.1:11434"; then
  ok "listening on 127.0.0.1:11434"
else
  fail "nothing listening on 127.0.0.1:11434"
fi

if TAGS=$(curl -sf --max-time 5 "$URL/api/tags"); then
  ok "API responds"
  if echo "$TAGS" | jq -e --arg m "$MODEL" '.models[] | select(.name == $m)' > /dev/null; then
    ok "model $MODEL is available"
  else
    fail "model $MODEL not found"
  fi
else
  fail "API did not respond"
fi

if [ "$FAILED" -eq 0 ]; then
  echo "HEALTHY"; exit 0
else
  echo "UNHEALTHY"; exit 1
fi
