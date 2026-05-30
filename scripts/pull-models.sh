#!/usr/bin/env bash
set -euo pipefail
MODELS=("qwen3:4b")
for model in "${MODELS[@]}"; do
  docker exec -it ollama ollama pull "$model"
done
