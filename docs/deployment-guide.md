# Deployment Guide

## Prerequisites

- Proxmox VE host
- Ubuntu 24.04 cloud-init template, recommended VMID `9024`
- OpenTofu installed on your workstation
- Ansible installed on your workstation or WSL
- Proxmox API token
- SSH key configured for the cloud-init user

## Deploy

```bash
cd opentofu
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars
tofu init
tofu apply

cd ../ansible
WSL

eval "$(ssh-agent -s)"
mkdir -p ~/.ssh

cp /mnt/c/Users/<your-windows-user>/.ssh/<matching-private-key> ~/.ssh/
chmod 600 ~/.ssh/<matching-private-key>

ssh-add ~/.ssh/<matching-private-key>

export ANSIBLE_CONFIG="$PWD/ansible.cfg"
ansible-galaxy collection install -r requirements.yml
ansible all -m ping
ansible-playbook site.yml
```

The deployed stack exposes Open WebUI directly over HTTP:

```text
http://192.168.86.254:3000
```

Ollama is available at:

```text
http://192.168.86.254:11434
```

Docker image and layer storage stays at `/var/lib/docker`, and the application stores persistent data under `/srv/ai`.

The app deployment pulls the current Open WebUI image each run, so rerunning Ansible updates Open WebUI when a newer `main` image is available without intentionally updating Ollama at the same time.
