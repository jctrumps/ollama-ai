# Troubleshooting

## Open WebUI cannot reach Ollama

```bash
cd /opt/ollama-ai
docker compose ps
docker compose logs ollama
docker compose logs open-webui
```

Confirm `OLLAMA_BASE_URL=http://ollama:11434` in the Open WebUI container environment.

## Disk is filling up

```bash
du -h -d 2 /srv/ai
```

Remove unused models:

```bash
docker exec -it ollama ollama list
docker exec -it ollama ollama rm <model-name>
```

## Model is slow

Use a smaller model first, such as `qwen3:4b` or `llama3.2:3b`.
