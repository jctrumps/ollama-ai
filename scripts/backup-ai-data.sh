#!/usr/bin/env bash
set -euo pipefail
BACKUP_DIR="${1:-$HOME/ollama-ai-backups}"
TS="$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
sudo tar -czf "$BACKUP_DIR/ollama-ai-$TS.tar.gz" /srv/ai /opt/ollama-ai
