resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = var.datastore_iso
  node_name    = var.node_name

  url                 = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name            = "tf-ubuntu-cloud"
  node_name       = var.node_name
  stop_on_destroy = true

  disk {
    datastore_id = var.datastore_vm
    file_id      = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  initialization {
    datastore_id = var.datastore_iso
    user_account {
      username = "ubuntu"
      password = "ubuntu"
      keys     = [trimspace(file("./ssh/id_terraform.pub"))]
    }


    dns {
      servers = ["8.8.8.8", "1.1.1.1"]
    }

    ip_config {
      ipv4 {
        address = "192.168.31.51/24"
        gateway = "192.168.31.1"
      }
    }
  }
  cpu {
    sockets = 1
    cores   = 2
  }
  memory {
    dedicated = 1024
  }
  # Устанавливаем агент для динамического получения IP
  agent {
    enabled = false
  }
  network_device {
    bridge = "vmbr0"
  }
}
