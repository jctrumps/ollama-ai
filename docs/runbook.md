# Runbook

## Check containers

```bash
ssh ollama-01
docker ps
cd /opt/ollama-ai
docker compose logs -f
```

## List models

```bash
docker exec -it ollama ollama list
```

## Pull a model

```bash
docker exec -it ollama ollama pull qwen3:4b
```

## Run a model

```bash
docker exec -it ollama ollama run qwen3:4b
```
