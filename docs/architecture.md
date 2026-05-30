# Architecture

`ollama-ai` runs local AI services on a dedicated Proxmox VM named `ollama-01`.

```text
Proxmox VE host
└── ollama-01 VM
    ├── Ubuntu Server 24.04 LTS
    ├── Docker Engine
    ├── Ollama
    └── Open WebUI
```

Docker runs inside the VM, not directly on the Proxmox host. This keeps the hypervisor clean while making the application stack portable and repeatable.
