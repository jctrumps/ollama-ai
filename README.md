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
| Proxmox datastore | `<proxmox-datastore>` |
| VM disk size | `500 GB` |
| App path | `/opt/ollama-ai` |
| Data path | `/srv/ai` |
| Ollama URL | `http://<vm-ip>:11434` |
| Open WebUI URL | `http://<vm-ip>:3000` |

## Current Status

The infrastructure and application stack are in a working baseline state:

- OpenTofu provisions the VM on the Proxmox datastore configured in local `terraform.tfvars`.
- Ansible configures Ubuntu, Docker, Ollama, Open WebUI, firewall rules, and model pulls.
- Docker data stays at `/var/lib/docker`; application data stays under `/srv/ai`.
- Open WebUI is exposed directly over HTTP on `http://<vm-ip>:3000`.
- Ollama responds on `http://<vm-ip>:11434`.
- `tinyllama:latest` is the Open WebUI default for fast CPU responses.
- `qwen3:30b-a3b` remains installed for higher-quality testing.
- Ollama is tuned for CPU-oriented use with bounded context, one loaded model, one active generation, and a small request queue.
- Open WebUI background task work is routed to TinyLlama, and follow-up/tag/autocomplete generation are disabled by default to reduce CPU use after answers.

Current decision:

- Use the VM IP address in the URL and plain HTTP. Do not rely on automatic hostname discovery.

Rejected for now:

- HTTPS/Caddy.
- Avahi/mDNS and LLMNR hostname discovery.
- Per-client hosts-file edits.
- Running a VM-hosted LAN DNS resolver.
- Router/DHCP DNS changes.

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
mkdir -p ~/.ssh
cp /mnt/c/Users/<your-windows-user>/.ssh/ollama_01_ed25519 ~/.ssh/ollama_01_ed25519
chmod 600 ~/.ssh/ollama_01_ed25519
export ANSIBLE_CONFIG="$PWD/ansible.cfg"
ansible-galaxy collection install -r requirements.yml
ansible all -m ping
ansible-playbook site.yml
```

### 3. Pull a starter model

```bash
ssh ubuntu@ollama-01
cd /opt/ollama-ai
docker exec -it ollama ollama pull tinyllama:latest
docker exec -it ollama ollama run tinyllama:latest
```

The Ansible deployment also pulls the configured starter model bundle and refreshes container images on each app deploy.

TinyLlama is pulled and warmed automatically when the Compose stack starts.

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

## HX5 storage model

The host uses a Proxmox-backed datastore for the VM disk, so the guest uses normal local Linux paths and does not mount the NAS directly.

- Proxmox storage: `<proxmox-datastore>`
- Backing NAS: `<nas-host>` at `<nas-ip>`
- Default VM disk size: `500 GB`
- AI data path: `/srv/ai`
- Docker data-root: `/var/lib/docker`
- Ollama models: `/srv/ai/ollama`
- Open WebUI data: `/srv/ai/open-webui`

All application storage now uses normal guest directories. No in-guest NFS or CIFS mount is required.

WSL Ansible commands expect the SSH private key at `~/.ssh/ollama_01_ed25519`.

## HTTP Access

Open WebUI is published directly over HTTP:

```text
http://<vm-ip>:3000
```

Ollama API:

```text
http://<vm-ip>:11434
```

No HTTPS proxy, local DNS, mDNS, LLMNR, or hosts-file workaround is part of the current design.

## Initial scope

Version 1 intentionally stays small:

- one Proxmox VM named `ollama-01`
- Ubuntu 24.04 cloud-init clone
- Docker Engine and Compose plugin
- Ollama container
- Open WebUI container
- explicit persistent storage under `/srv/ai`
- LAN-only HTTP default security posture

Future phases can add RAG, vector storage, reverse proxy/TLS, observability integration, and multiple Ollama nodes.
