terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

resource "proxmox_lxc" "app_container" {
  target_node = var.target_node
  hostname    = var.vm_hostname
  ostemplate  = var.ostemplate
  password    = "password"

  ssh_public_keys = var.ssh_public_key

  cores  = var.lxc_resources.cores
  memory = var.lxc_resources.memory
  swap   = var.lxc_resources.swap

  rootfs {
    storage = var.storage
    size    = var.size
  }

  network {
    name     = "eth0"
    bridge   = var.bridge
    ip       = var.ip_address
    gw       = var.gateway
    firewall = true
  }

  start = true  # Контейнер будет запущен сразу после создания

  # Конфигурация и установка ПО (nginx и др.) должны происходить вне Terraform

  connection {
    type        = "ssh"
    host        = var.ip_address
    user        = "root"
    private_key = var.private_key
    timeout     = "2m"
  }


}
