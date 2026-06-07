# Documentation Index

Use this directory as the operator-facing reference for the `ollama-ai` stack.

## Core Docs

- `architecture.md`: high-level VM and service layout.
- `deployment-guide.md`: end-to-end provisioning and deployment steps.
- `runbook.md`: day-2 operational commands.
- `troubleshooting.md`: common failure cases and quick checks.

## Current Status

The VM, Docker stack, Open WebUI, and Ollama API are working by direct IP. The project currently uses plain HTTP by IP and does not use HTTPS, Caddy, mDNS, LLMNR, VM-hosted DNS, router DNS changes, or hosts-file edits.

Current access URLs:

- Open WebUI: `http://192.168.86.254:3000`
- Ollama API: `http://192.168.86.254:11434`

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
