locals {
  ssh_key = trimspace(file("${path.module}/ssh/id_terraform.pub"))

  install_cmd = templatefile("${path.module}/templates/install.tpl", {
    package = "nginx"
  })

  ssh_map = merge({
    for name, cfg in var.containers :
    name => {
      ip   = cfg.ip
      key  = trimspace(cfg.ssh)
    }
  })

  startup_info = [
    for name in keys(var.containers) :
    "Container ${name} → ${var.containers[name].ip}"
  ]

  joined_startup_info = join("", local.startup_info)
}

resource "proxmox_lxc" "ct" {
  for_each     = var.containers
  hostname     = each.key
  target_node  = "homeserv"
  ostemplate   = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  # unprivileged = true
  cores        = 2
  memory       = each.value.memory
  start        = true
  password     = "password"  # Устанавливаем пароль для root

  ssh_public_keys = local.ssh_key

  rootfs {
    storage = "storage"
    size    = "8G"
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "${each.value.ip}/24"
    gw     = "192.168.31.1"
  }

  connection {
    type        = "ssh"
    user        = "root"
    private_key = file("${path.module}/ssh/id_terraform")
    host        = each.value.ip
    timeout     = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      local.install_cmd
    ]
  }
}

output "container_ips" {
  value = [for c in var.containers : c.ip]
}
