#!/usr/bin/env bash
# InferOps benchmark: average tokens/sec over N requests.
set -euo pipefail

URL="http://127.0.0.1:11434/api/generate"
MODEL="${MODEL:-qwen2.5:0.5b}"
RUNS="${RUNS:-3}"
PROMPT="Explain what a Linux service is in two sentences."

echo "Model: $MODEL | Runs: $RUNS"
total=0
for i in $(seq 1 "$RUNS"); do
  body=$(jq -n --arg m "$MODEL" --arg p "$PROMPT" '{model:$m, prompt:$p, stream:false}')
  tps=$(curl -sf "$URL" -d "$body" | jq '.eval_count / (.eval_duration / 1e9)')
  printf "run %d: %.1f tokens/sec\n" "$i" "$tps"
  total=$(echo "$total + $tps" | bc -l)
done
avg=$(echo "$total / $RUNS" | bc -l)
printf "average: %.1f tokens/sec\n" "$avg"
