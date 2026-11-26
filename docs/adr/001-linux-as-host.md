# ADR-001: Linux as the host OS

Status: Accepted
Date: 2026-11-26

## Context
InferOps serves open-source AI models. The production target is cloud
servers and Kubernetes, which run Linux. The dev machine is a Windows laptop.

## Options
1. Windows directly: model tools work, but production does not look like this.
2. A cloud VM from day one: closest to production, but costs money and needs internet.
3. Linux on WSL2 (Ubuntu 24.04): free, local, same commands as production.

## Decision
Use Ubuntu 24.04 on WSL2 for development.

## Consequences
- Same tools as production: systemd, apt, bash, Docker.
- RAM is shared with Windows (7.6 GiB visible), so models must stay small.
- No GPU: CPU inference only.
- Largest practical model: about 3B parameters at 4-bit (~2 GB in RAM).
  Starting model: qwen2.5:0.5b (~400 MB) for fast iteration.
