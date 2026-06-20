# AGENTS

## Project Summary

`ollama-ai` provisions and configures a dedicated Proxmox VM for a small local AI stack:

- OpenTofu creates the VM.
- Ansible configures Ubuntu, Docker, and the application.
- Docker Compose runs `ollama` and `open-webui`.

Default target values used across the repo:

- VM name: `ollama-01`
- Proxmox datastore: `<proxmox-datastore>`
- VM disk size: `500 GB`
- App path: `/opt/ollama-ai`
- Data path: `/srv/ai`
- Ollama port: `11434`
- Open WebUI URL: `http://<vm-ip>:3000`

Current project state:

- Open WebUI and Ollama are deployed and reachable by IP.
- The project intentionally uses direct HTTP by IP for now.
- Open WebUI defaults to `tinyllama:latest`; `qwen3:30b-a3b` remains installed for higher-quality testing.
- TinyLlama is warmed at stack startup, and Open WebUI background task work is routed to TinyLlama to reduce CPU load.
- HTTPS, Caddy, Avahi/mDNS, LLMNR, explicit IPv4 mDNS publishing, VM-hosted DNS, router DNS changes, and per-client hosts-file edits are not part of the current configuration.
- Do not reintroduce HTTPS or hostname discovery without an explicit new planning decision.

## Repository Map

- `opentofu/`: Proxmox VM definition and generated Ansible inventory.
- `ansible/`: host configuration, Docker install, app deployment, firewall.
- `compose/`: runtime container definition copied onto the VM.
- `scripts/`: wrapper deployment scripts.
- `docs/`: operator-facing documentation.
- `.env.example`: compose environment defaults copied to the VM as `.env`.

## Working Rules

- Keep layers separated. Infrastructure changes belong in OpenTofu, host configuration in Ansible, and container runtime changes in Compose.
- Prefer changing the smallest layer that solves the problem.
- Update docs when changing defaults, ports, paths, or deployment steps.
- Never commit secrets, API tokens, private keys, or filled-in vault files.
- Treat `opentofu/.terraform/**`, `opentofu/terraform.tfstate`, and `ansible/inventory/hosts.ini` as generated artifacts unless the task is explicitly about them.

## Project-Specific Notes

- `opentofu/main.tf` writes `ansible/inventory/hosts.ini` via `local_file`.
- `ansible/group_vars/ollama.yml` is the main source for deployment paths and starter models.
- `ansible/roles/ai_stack/tasks/main.yml` copies `compose/compose.yml` and `.env.example` to `/opt/ollama-ai` on the VM.
- Open WebUI is exposed directly on host port `3000`; Caddy is not used.
- `ansible/roles/base/tasks/main.yml` installs base packages and enables the qemu guest agent.
- The VM disk is intended to live on a Proxmox datastore selected in local OpenTofu configuration; the guest does not mount the NAS directly.
- The initial model list pulls a mixed CPU-oriented starter bundle. Open WebUI defaults to `tinyllama:latest`, which is also warmed by a one-shot Compose service at stack startup.
- `qwen3:30b-a3b` remains installed for higher-quality testing.
- CPU defaults use bounded context, one loaded model, one active generation, and a small request queue.
- Open WebUI task work is routed to TinyLlama, with follow-up, tag, and autocomplete generation disabled by default to reduce background CPU work.
- App deploy pulls the current Open WebUI image so it updates when the upstream `main` image changes.

## Safe Validation

Run the narrowest checks that match the layer you touched:

- OpenTofu: `tofu fmt` in `opentofu/`
- Ansible: `ansible-playbook --syntax-check site.yml` in `ansible/`
- Compose: `docker compose --env-file .env.example -f compose/compose.yml config`

If a required tool is unavailable, state that clearly in the handoff.

## Docs To Keep In Sync

When behavior changes, review these files for drift:

- `README.md`
- `docs/README.md`
- `docs/deployment-guide.md`
- `docs/runbook.md`
- `docs/troubleshooting.md`
