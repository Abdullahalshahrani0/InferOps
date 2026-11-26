# InferOps

Self-hosted AI model platform — built as code, autoscaling, and observable.

An internal AI assistant for companies that cannot send their data to external
AI APIs. Open-source models run on the company's own servers, behind a gateway
that routes each request to the right model and caches repeated answers to cut cost.

## Architecture (target)
Chat UI → Nginx (TLS, rate limit) → AI Gateway (FastAPI: routing + cache)
→ Ollama models — on Kubernetes (Helm + HPA), provisioned on AWS with
Terraform and Ansible, deployed by GitHub Actions, monitored with
Prometheus, Grafana and Loki.

## Roadmap
- [x] Stage 1 — Repo, host inventory, ADR-001
- [ ] Stage 2 — Linux model server (Ollama as a systemd service)
- [ ] Stage 3 — Bash automation
- [ ] Stage 4 — Python API (FastAPI)
- [ ] Stage 5 — Docker and Docker Compose
- [ ] Stage 6 — CI/CD with GitHub Actions
- [ ] Stage 7 — Nginx, TLS, rate limiting
- [ ] Stage 8 — AI gateway: routing and caching
- [ ] Stage 9 — AWS with Terraform
- [ ] Stage 10 — Ansible
- [ ] Stage 11 — Kubernetes, Helm, autoscaling
- [ ] Stage 12 — Monitoring
- [ ] Stage 13 — Chat UI and live dashboard

## Docs
- [Host inventory](docs/host-inventory.md)
- [Architecture decisions](docs/adr/)
