#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../ansible"
export ANSIBLE_CONFIG="$PWD/ansible.cfg"
if [ ! -f "$HOME/.ssh/ollama_01_ed25519" ]; then
  echo "Missing SSH key: $HOME/.ssh/ollama_01_ed25519" >&2
  echo "Copy it from Windows before running this script." >&2
  exit 1
fi
ansible-galaxy collection install -r requirements.yml
ansible all -m ping
ansible-playbook site.yml
