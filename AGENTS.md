# AGENTS

## Project Summary

`ollama-ai` provisions and configures a dedicated Proxmox VM for a small local AI stack:

- OpenTofu creates the VM.
- Ansible configures Ubuntu, Docker, and the application.
- Docker Compose runs `ollama` and `open-webui`.

Default target values used across the repo:

- VM name: `ollama-01`
- App path: `/opt/ollama-ai`
- Data path: `/srv/ai`
- Ollama port: `11434`
- Open WebUI port: `3000`

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
- `ansible/group_vars/ollama_vault.yml.example` is a template only; real secrets should stay outside Git.
- `ansible/roles/ai_stack/tasks/main.yml` copies `compose/compose.yml` and `.env.example` to `/opt/ollama-ai` on the VM.
- The initial model list currently defaults to `qwen3:0.6b`.

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
