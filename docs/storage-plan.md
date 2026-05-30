# Storage Plan

Recommended paths:

```text
/opt/ollama-ai          # compose file and runtime config
/srv/ai/ollama         # Ollama models and manifests
/srv/ai/open-webui     # Open WebUI database and uploads
```

Prefer local Proxmox storage for active model data. Use NAS storage for backups and archived models.
