terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "https://192.168.31.100:8006/api2/json"
  pm_api_token_id     = "terraform@pve!tf"
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = true
}


locals {
  ssh_key     = file("${path.module}/ssh/id_ed25519.pub")
  install_cmd = templatefile("${path.module}/templates/install.tpl", {
    package = "nginx"
  })
}

resource "proxmox_lxc" "ct" {
  hostname     = "ct-web01"
  target_node  = "homeserv"
  ostemplate   = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  password     = "password"
  ssh_public_keys = local.ssh_key
  memory       = 1024
  cores        = 2
  start        = true

  rootfs {
    storage = "storage"
    size    = "8G"
  }

  network {
    name     = "eth0"
    bridge   = "vmbr0"
    ip       = "192.168.31.50/24"
    gw       = "192.168.31.1"
  }

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("${path.module}/ssh/id_ed25519")
    host        = "192.168.31.50"
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      local.install_cmd
    ]
  }
}
