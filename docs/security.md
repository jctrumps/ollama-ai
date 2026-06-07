# Security

Default posture:

- Keep Ollama and Open WebUI LAN-only.
- Publish Open WebUI directly over HTTP on port `3000` for LAN use only.
- Do not expose port `11434` directly to the internet.
- Use a VPN for remote access.
- Add authentication to Open WebUI before wider access.
- Move secrets into Ansible Vault before production use.
- Back up `/srv/ai` before major upgrades.

Current note:

- Do not add HTTPS/Caddy, local hostname discovery, a VM-hosted DNS resolver, router DNS changes, or per-client hosts-file workarounds without a new planning decision.
