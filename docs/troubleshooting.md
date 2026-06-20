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
http://<vm-ip>:3000
```

Check containers on the VM:

```bash
cd /opt/ollama-ai
docker compose ps
docker compose logs open-webui
```

Check from Windows:

```powershell
curl.exe http://<vm-ip>:3000/
```

If the browser cannot load the page, verify port `3000` is open and the container is running.

## Ollama API

```powershell
curl.exe http://<vm-ip>:11434/api/version
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

First-token delay is expected after a cold start because Ollama must load model weights from disk into RAM. The current Open WebUI default is `tinyllama:latest`, which should have much lower delay than larger models. `qwen3:30b-a3b` is still available for higher-quality testing and may show a longer delay before CPU usage rises.

The current global context length is `2048`, which is a CPU-oriented compromise. If TinyLlama still feels slow for short prompts, lower `OLLAMA_CONTEXT_LENGTH` to `1024`. If larger models need better long-context behavior, raise it to `4096` and expect slower prompt processing.

For Qwen3 models, simple prompts can be slow because the model generates a long `thinking` stream before the visible answer. Use this for direct answers:

```text
/no_think say hello
```

For direct Ollama API calls, use `"think": false`:

```powershell
curl.exe http://<vm-ip>:11434/api/generate -d '{"model":"qwen3:30b-a3b","prompt":"say hello","stream":true,"think":false,"options":{"num_predict":64,"num_ctx":2048}}'
```

Open WebUI background tasks can also consume CPU after an answer. The Compose defaults route task work to `tinyllama:latest`, keep title generation enabled, and disable follow-up, tag, and autocomplete generation.

Important: Open WebUI marks these as persistent config values. On an existing instance, environment changes can be ignored if values were already saved in the Open WebUI database. If the UI still uses the large model for task work, set the task model and background generation toggles in the Open WebUI Admin Settings.

Check loaded models:

```bash
docker exec -it ollama ollama ps
```

Check the startup warmup container:

```bash
cd /opt/ollama-ai
docker compose logs ollama-warmup
```

If generation appears wedged, restart only Ollama:

```bash
cd /opt/ollama-ai
docker compose restart ollama
```
