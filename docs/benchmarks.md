# Benchmarks

Host: Intel i5-13420H, 12 cores, 7.6 GiB RAM (WSL2), CPU only.
Model: qwen2.5:0.5b (397 MB). Date: 2026-11-26.

| Metric | Value |
|--------|-------|
| Generation speed | ~79 tokens/sec |
| Model load time (cold) | ~1.0 s |
| Tokens in test answer | 220 |

## Observations
- Fast enough for an interactive chat on CPU only.
- Quality limit: with Arabic-only technical terms the 0.5B model hallucinated
  a fully invented answer. With the English term it answered correctly.
  This is the reason for the gateway in Stage 8: route hard or Arabic
  questions to a larger model.
