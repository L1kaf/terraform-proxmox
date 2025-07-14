output "vm_hostname" {
  value = [for lxc in proxmox_lxc.demo : lxc.hostname]
}
