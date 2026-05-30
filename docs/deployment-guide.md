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

eval "$(ssh-agent -s)"
mkdir -p ~/.ssh

cp /mnt/c/Users/<your-windows-user>/.ssh/<matching-private-key> ~/.ssh/
chmod 600 ~/.ssh/<matching-private-key>

ssh-add ~/.ssh/<matching-private-key>

cd ../ansible
export ANSIBLE_CONFIG="$PWD/ansible.cfg"
ansible-galaxy collection install -r requirements.yml
ansible all -m ping
ansible-playbook site.yml
```
