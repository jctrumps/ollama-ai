# Runbook

## Check containers

```bash
ssh ollama-01
docker ps
cd /opt/ollama-ai
docker compose logs -f
```

## Check direct client access

From Windows or another LAN client:

```powershell
curl.exe http://192.168.86.254:3000/
curl.exe http://192.168.86.254:11434/api/version
```

These checks use direct IP access only.

## List models

```bash
docker exec -it ollama ollama list
```

## Pull a model

```bash
docker exec -it ollama ollama pull qwen3:30b-a3b
```

## Run a model

```bash
docker exec -it ollama ollama run qwen3:30b-a3b
```

## Update Open WebUI

The Ansible app deployment pulls the current `ghcr.io/open-webui/open-webui:main` image:

```bash
cd /mnt/c/projects/ollama-ai/ansible
ansible-playbook -i inventory/hosts.ini site.yml
```
