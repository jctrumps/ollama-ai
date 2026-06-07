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
docker exec -it ollama ollama pull tinyllama:latest
```

## Run a model

```bash
docker exec -it ollama ollama run tinyllama:latest
```

## Warm Default Model

The Compose stack includes a one-shot `ollama-warmup` container that pulls `tinyllama:latest` only if missing and warms it when the stack starts.

To warm it manually:

```bash
curl -sS http://127.0.0.1:11434/api/generate \
  -H 'Content-Type: application/json' \
  -d '{"model":"tinyllama:latest","prompt":"warm up","stream":false,"keep_alive":"1h","options":{"num_predict":1,"num_ctx":2048}}'
```

## CPU Tuning

Current defaults are optimized for single-user CPU inference:

- `OLLAMA_CONTEXT_LENGTH=2048`
- `OLLAMA_MAX_LOADED_MODELS=1`
- `OLLAMA_NUM_PARALLEL=1`
- `OLLAMA_MAX_QUEUE=4`

Use `1024` context for maximum TinyLlama responsiveness, or `4096` for better long-context quality at the cost of slower prompt processing.

## Qwen3 Thinking

For simple prompts with Qwen3 models, use `/no_think` to avoid long thinking output:

```text
/no_think say hello
```

For direct Ollama API tests, disable thinking explicitly:

```bash
curl -sS http://127.0.0.1:11434/api/generate \
  -H 'Content-Type: application/json' \
  -d '{"model":"qwen3:30b-a3b","prompt":"say hello","stream":true,"think":false,"options":{"num_predict":64,"num_ctx":2048}}'
```

Use `/think` when the extra reasoning is worth the CPU time.

## Open WebUI Background Tasks

Open WebUI is configured to use `tinyllama:latest` for task work and to disable follow-up, tag, and autocomplete generation by default. If an existing Open WebUI database ignores those environment values, set them in the Admin Settings because Open WebUI persists those config values internally.

## Update Open WebUI

The Ansible app deployment pulls the current `ghcr.io/open-webui/open-webui:main` image:

```bash
cd /mnt/c/projects/ollama-ai/ansible
ansible-playbook -i inventory/hosts.ini site.yml
```
