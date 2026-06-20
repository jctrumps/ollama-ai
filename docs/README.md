# Documentation Index

Use this directory as the operator-facing reference for the `ollama-ai` stack.

## Core Docs

- `architecture.md`: high-level VM and service layout.
- `deployment-guide.md`: end-to-end provisioning and deployment steps.
- `runbook.md`: day-2 operational commands.
- `troubleshooting.md`: common failure cases and quick checks.

## Current Status

The VM, Docker stack, Open WebUI, and Ollama API are working by direct IP. The project currently uses plain HTTP by IP and does not use HTTPS, Caddy, mDNS, LLMNR, VM-hosted DNS, router DNS changes, or hosts-file edits.

Current model/runtime defaults:

- Open WebUI default model: `tinyllama:latest`.
- Higher-quality test model retained: `qwen3:30b-a3b`.
- TinyLlama is pulled and warmed by the one-shot `ollama-warmup` Compose service at stack startup.
- Ollama is configured for CPU-oriented use: context length `2048`, one loaded model, one active generation, and queue size `4`.
- Open WebUI task work uses TinyLlama; follow-up, tag, and autocomplete generation are disabled by default.

Current access URLs:

- Open WebUI: `http://<vm-ip>:3000`
- Ollama API: `http://<vm-ip>:11434`

## Supporting Docs

- `model-guide.md`: starter model choices and performance tracking.
- `security.md`: default LAN-only security posture.
- `ssh-guide.md`: SSH key setup and access patterns.
- `storage-plan.md`: expected runtime storage layout.

## When To Update Docs

Update this folder when changes affect:

- deployment order or required tools
- VM defaults, ports, storage paths, or model defaults
- remote access, SSH, or security posture
- routine operations or recovery steps
