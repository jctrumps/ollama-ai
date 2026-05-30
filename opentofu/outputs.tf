output "vm_name" {
  value = proxmox_virtual_environment_vm.ollama.name
}

output "vm_id" {
  value = proxmox_virtual_environment_vm.ollama.vm_id
}

output "ansible_inventory" {
  value = local_file.ansible_inventory.filename
}
