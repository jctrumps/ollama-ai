variable "proxmox_endpoint" {
  description = "Proxmox API endpoint, for example https://pve.example.local:8006/"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token in user@realm!token=value format. Prefer environment or tfvars kept out of Git."
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Allow insecure TLS for lab Proxmox certificates."
  type        = bool
  default     = true
}

variable "node_name" {
  description = "Proxmox node name."
  type        = string
}

variable "vm_id" {
  description = "Target VM ID for ollama-01."
  type        = number
  default     = 9101
}

variable "vm_name" {
  description = "VM and hostname."
  type        = string
  default     = "ollama-01"
}

variable "template_vm_id" {
  description = "Existing Ubuntu 24.04 cloud-init template VM ID."
  type        = number
  default     = 9024
}

variable "cpu_cores" {
  type    = number
  default = 8
}

variable "memory_mb" {
  type    = number
  default = 32768
}

variable "disk_size_gb" {
  type    = number
  default = 500
}

variable "datastore_id" {
  type    = string
  default = "mycloudpr2100"
}

variable "bridge" {
  type    = string
  default = "vmbr0"
}

variable "ipv4_address" {
  description = "CIDR address, for example 192.168.1.51/24. Leave null if using DHCP."
  type        = string
  default     = null
}

variable "ipv4_gateway" {
  description = "Gateway address, for example 192.168.1.1. Leave null if using DHCP."
  type        = string
  default     = null
}

variable "ssh_public_key" {
  description = "Public SSH key for cloud-init user."
  type        = string
}

variable "cpu_type" {
  description = "Proxmox CPU type/model. Use 'host' to expose host CPU features to the VM."
  type        = string
  default     = "host"
}
