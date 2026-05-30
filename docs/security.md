# Security

Default posture:

- Keep Ollama and Open WebUI LAN-only.
- Do not expose port `11434` directly to the internet.
- Use a VPN for remote access.
- Add authentication to Open WebUI before wider access.
- Move secrets into Ansible Vault before production use.
- Back up `/srv/ai` before major upgrades.
