# Initial Proxmox VM definition for ollama-01.
# This assumes a pre-existing Ubuntu 24.04 cloud-init template, such as VMID 9024.

resource "proxmox_virtual_environment_vm" "ollama" {
  name      = var.vm_name
  node_name = var.node_name
  vm_id     = var.vm_id

  clone {
    vm_id = var.template_vm_id
    full  = true
  }

  agent {
    enabled = true
  }

  cpu {
    cores = var.cpu_cores
    type  = var.cpu_type
  }

  memory {
    dedicated = var.memory_mb
  }

  network_device {
    bridge = var.bridge
    model  = "virtio"
  }

  disk {
    datastore_id = var.datastore_id
    interface    = "scsi0"
    size         = var.disk_size_gb
  }

  initialization {
    user_account {
      username = "ubuntu"
      keys     = [var.ssh_public_key]
    }

    ip_config {
      ipv4 {
        address = var.ipv4_address == null ? "dhcp" : var.ipv4_address
        gateway = var.ipv4_gateway
      }
    }
  }
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory/hosts.ini"
  content  = <<-EOT
  [ollama]
  ${var.vm_name} ansible_host=${var.ipv4_address == null ? var.vm_name : split("/", var.ipv4_address)[0]} ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3.12 ansible_ssh_private_key_file=~/.ssh/ollama_01_ed25519 ansible_ssh_common_args='-o IdentitiesOnly=yes'
  EOT
}
