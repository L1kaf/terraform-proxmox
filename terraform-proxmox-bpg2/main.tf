resource "proxmox_virtual_environment_container" "ubuntu_lxc" {
  node_name    = "homeserv"
#   vm_id        = 101
  description  = "LXC Container managed by Terraform"
  unprivileged = true

  cpu {
    cores = 2
    units = 1024
  }

  memory {
    dedicated = 512
    swap      = 256
  }

  network_interface {
    name   = "eth0"
    bridge = "vmbr0"
  }

  disk {
    datastore_id = "storage"
    size         = 8
  }

  operating_system {
    template_file_id = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
    type             = "ubuntu"
  }

  initialization {
    hostname = "ubuntu-lxc"
    ip_config {
      ipv4 {
        address = "192.168.31.50/24"
        gateway = "192.168.31.1"
      }
    }
    user_account {
      password = "password"
      keys = [trimspace(file("${path.module}/ssh/id_terraform.pub"))]
    }
  }

  features {
    nesting = true
  }

  startup {
    order      = 1
    up_delay   = 30
    down_delay = 30
  }

  protection = false
  template   = false
  started    = true
}
