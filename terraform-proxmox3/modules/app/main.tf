terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

resource "proxmox_lxc" "web" {
  hostname         = "app"
  ostemplate       = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  target_node      = "homeserv"
  password         = "password"
  cores            = 1
  memory           = 1024
  ssh_public_keys  = file("${path.module}/../../ssh/id_terraform.pub")

  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  network {
    name     = "eth0"
    bridge   = "vmbr0"
    ip       = "192.168.31.202/24"
    gw       = "192.168.31.1"
    firewall = true
  }

  start = true

  provisioner "remote-exec" {
    inline = [
      "echo Приложение подключится к БД на ${var.db_host}"
    ]
  }

  connection {
    type        = "ssh"
    host        = "192.168.31.202"
    user        = "root"
    private_key = file("${path.module}/../../ssh/id_terraform")
    timeout     = "2m"
  }
}
