SHELL := /bin/bash

.PHONY: infra-init infra-plan infra-apply infra-destroy ping app deploy logs ps

infra-init:
	cd opentofu && tofu init

infra-plan:
	cd opentofu && tofu plan

infra-apply:
	cd opentofu && tofu apply

infra-destroy:
	cd opentofu && tofu destroy

ping:
	cd ansible && ANSIBLE_CONFIG=ansible.cfg ansible all -m ping

app:
	cd ansible && ANSIBLE_CONFIG=ansible.cfg ansible-playbook site.yml

deploy:
	./scripts/deploy-all.sh

logs:
	ssh $${OLLAMA_SSH_HOST:-ollama-01} 'cd /opt/ollama-ai && docker compose logs -f'

ps:
	ssh $${OLLAMA_SSH_HOST:-ollama-01} 'docker ps'
