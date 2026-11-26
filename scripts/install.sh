#!/usr/bin/env bash
# InferOps installer: sets up the model server on a fresh Ubuntu host.
# Idempotent: safe to run many times.
set -euo pipefail

MODEL="${MODEL:-qwen2.5:0.5b}"
REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"

log() { echo "==> $1"; }

if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root: sudo $0"; exit 1
fi

log "Installing packages"
apt-get update -qq
apt-get install -y -qq curl jq zstd bc > /dev/null

log "Creating system user"
if id inferops &>/dev/null; then
  echo "    user inferops already exists"
else
  useradd --system --no-create-home --shell /usr/sbin/nologin inferops
fi

log "Creating directories"
mkdir -p /opt/inferops /etc/inferops /var/lib/inferops/models /var/log/inferops
chown -R inferops:inferops /var/lib/inferops /var/log/inferops
chmod 750 /var/lib/inferops /var/log/inferops

log "Installing Ollama"
if command -v ollama &>/dev/null; then
  echo "    ollama already installed: $(ollama -v 2>/dev/null | tail -1)"
else
  curl -fsSL https://ollama.com/download/ollama-linux-amd64.tar.zst | tar --zstd -x -C /usr
fi

log "Installing systemd unit"
install -m 644 "$REPO_DIR/deploy/systemd/inferops-model.service" /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now inferops-model

log "Installing scripts and health check timer"
mkdir -p /opt/inferops/scripts
install -m 755 "$REPO_DIR"/scripts/*.sh /opt/inferops/scripts/
install -m 644 "$REPO_DIR"/deploy/systemd/inferops-healthcheck.* /etc/systemd/system/
systemctl daemon-reload
systemctl enable --now inferops-healthcheck.timer

log "Waiting for API"
for _ in $(seq 1 20); do
  curl -sf http://127.0.0.1:11434/api/tags > /dev/null && break
  sleep 1
done

log "Pulling model $MODEL"
ollama pull "$MODEL" > /dev/null

log "Health check"
"$REPO_DIR/scripts/healthcheck.sh"
