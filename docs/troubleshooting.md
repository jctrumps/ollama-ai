# Troubleshooting

## Open WebUI cannot reach Ollama

```bash
cd /opt/ollama-ai
docker compose ps
docker compose logs ollama
docker compose logs open-webui
```

Confirm `OLLAMA_BASE_URL=http://ollama:11434` in the Open WebUI container environment.

## Browser Access

Open WebUI is intentionally served over plain HTTP by IP:

```text
http://192.168.86.254:3000
```

Check containers on the VM:

```bash
cd /opt/ollama-ai
docker compose ps
docker compose logs open-webui
```

Check from Windows:

```powershell
curl.exe http://192.168.86.254:3000/
```

If the browser cannot load the page, verify port `3000` is open and the container is running.

## Ollama API

```powershell
curl.exe http://192.168.86.254:11434/api/version
```

Expected result: a JSON version response.

## Disk is filling up

```bash
df -h /
du -h -d 2 /var/lib/docker
du -h -d 2 /srv/ai
```

Remove unused models:

```bash
docker exec -it ollama ollama list
docker exec -it ollama ollama rm <model-name>
```

## Model is slow

First-token delay is expected after a cold start because Ollama must load model weights from disk into RAM. The current preferred default is `qwen3:30b-a3b`; it may show a delay before CPU usage rises, then run normally once loaded.

Check loaded models:

```bash
docker exec -it ollama ollama ps
```

If generation appears wedged, restart only Ollama:

```bash
cd /opt/ollama-ai
docker compose restart ollama
```
