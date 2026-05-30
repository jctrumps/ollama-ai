# ollama-ai

Local Ollama AI stack for Proxmox VE using OpenTofu, Ansible, and Docker Compose.

## Architecture

```text
Proxmox VE
└── VM: ollama-01
    ├── Ubuntu Server 24.04 LTS cloud-init template clone
    ├── Docker Engine + Docker Compose plugin
    ├── Ollama container
    └── Open WebUI container
```

This project follows the same layered pattern as the rest of the homelab infrastructure:

```text
OpenTofu -> creates the Proxmox VM
Ansible  -> configures the VM
Compose  -> runs Ollama and Open WebUI
Docs     -> explain operations, security, models, and recovery
```

## Default target

| Setting | Value |
|---|---|
| Repo | `ollama-ai` |
| VM name | `ollama-01` |
| OS | Ubuntu Server 24.04 LTS |
| Template | `ubuntu-2404-cloudinit` |
| App path | `/opt/ollama-ai` |
| Data path | `/srv/ai` |
| Ollama URL | `http://<vm-ip>:11434` |
| Open WebUI URL | `http://<vm-ip>:3000` |

## Quick start

### 1. Provision the VM

```bash
cd opentofu
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars

tofu init
tofu plan
tofu apply
```

OpenTofu should generate or help populate:

```text
ansible/inventory/hosts.ini
```

### 2. Deploy the application stack

```bash
cd ../ansible
cp group_vars/ollama_vault.yml.example group_vars/ollama_vault.yml
export ANSIBLE_CONFIG="$PWD/ansible.cfg"
ansible-galaxy collection install -r requirements.yml
ansible all -m ping
ansible-playbook site.yml
```

### 3. Pull a starter model

```bash
ssh ubuntu@ollama-01
cd /opt/ollama-ai
docker exec -it ollama ollama pull qwen3:4b
docker exec -it ollama ollama run qwen3:4b
```

## Makefile helpers

```bash
make infra-init
make infra-plan
make infra-apply
make ping
make app
make deploy
```

## Documentation

- Docs index: `docs/README.md`
- Deployment guide: `docs/deployment-guide.md`
- Runbook: `docs/runbook.md`
- Agent guidance: `AGENTS.md`

## Initial scope

Version 1 intentionally stays small:

- one Proxmox VM named `ollama-01`
- Ubuntu 24.04 cloud-init clone
- Docker Engine and Compose plugin
- Ollama container
- Open WebUI container
- explicit persistent storage under `/srv/ai`
- LAN-only default security posture

Future phases can add RAG, vector storage, reverse proxy/TLS, observability integration, and multiple Ollama nodes.
