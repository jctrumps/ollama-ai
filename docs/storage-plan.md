# Storage Plan

This deployment stores the VM disk on a Proxmox-backed datastore configured locally. The guest no longer mounts the NAS directly.

## Proxmox Storage Layout

- Proxmox storage: `<proxmox-datastore>`
- NAS host: `<nas-host>`
- NAS IP: `<nas-ip>`
- VM disk size default: `500 GB`

## VM Storage Layout

```text
/                                   # guest root filesystem on the configured Proxmox datastore
/opt/ollama-ai                      # compose file and runtime config
/var/lib/docker                     # Docker image and layer storage
/srv/ai/ollama                      # Ollama models and manifests
/srv/ai/open-webui                  # Open WebUI database and uploads
```

## Deployment Guardrails

OpenTofu places the VM disk on the configured Proxmox datastore. Ansible creates normal local directories inside the guest.

The playbook refuses to deploy the AI stack when either condition is true:

- Docker Root Dir is anything other than `/var/lib/docker`

This keeps Docker on a supported local filesystem while storing both Docker layers and AI data on the VM disk backed by Proxmox NAS storage.

Resolved storage issues:

- The original 20 GB local disk approach ran out of space.
- Moving Docker data-root to an in-guest NAS mount caused Docker/containerd failures.
- The current design keeps Docker on the guest filesystem and relies on the VM disk living on the configured Proxmox datastore.
