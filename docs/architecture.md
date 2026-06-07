# Architecture

`ollama-ai` runs local AI services on a dedicated Proxmox VM named `ollama-01`.

```text
Proxmox VE host
└── mycloudpr2100 datastore
    └── ollama-01 VM
    ├── Ubuntu Server 24.04 LTS
    ├── Docker Engine
    ├── Ollama
    └── Open WebUI
```

Docker runs inside the VM, not directly on the Proxmox host. The VM disk lives on Proxmox storage `mycloudpr2100`, while the guest uses normal local Linux paths such as `/var/lib/docker` and `/srv/ai`.

## Network Access

- Ollama listens on LAN port `11434`.
- Open WebUI listens on LAN port `3000` over HTTP.
- Caddy, HTTPS, mDNS, LLMNR, VM-hosted DNS, and hosts-file workarounds are not part of the current design.

Current URLs:

- `http://192.168.86.254:3000`
- `http://192.168.86.254:11434`
