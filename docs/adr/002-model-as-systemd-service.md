# ADR-002: Run the model server as a systemd service

Status: Accepted
Date: 2026-11-26

## Context
The model server (Ollama) must start on boot, restart on crash, keep logs,
and run with the least privilege possible.

## Options
1. Run `ollama serve` in a terminal: dies when the terminal closes, no restart, no logs.
2. Use the official install script: works, but hides the setup and runs as its own default user.
3. Manual install + our own systemd unit: full control over user, paths and security.

## Decision
Manual install, with our own unit file stored in the repo
(deploy/systemd/inferops-model.service).

- Runs as a dedicated system user `inferops` (no login shell, no home login).
- Listens on 127.0.0.1:11434 only — not exposed to the network.
- Models stored in /var/lib/inferops/models.
- Restart=always, RestartSec=3.
- NoNewPrivileges and PrivateTmp enabled.

## Consequences
- Verified self-healing: `kill -9` on the main PID, systemd restarted it
  with a new PID in under 5 seconds.
- Logs available through `journalctl -u inferops-model`.
- Other services must reach the model through localhost, or through a
  gateway later (Nginx / API).
