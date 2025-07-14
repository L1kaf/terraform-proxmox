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

resource "proxmox_lxc" "app_container" {
  target_node = "homeserv"                                                       # узел Proxmox
  hostname    = "app-01"                                                   # имя контейнера
  ostemplate  = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst" # шаблон LXC
  password    = "password"                                                 # пароль root для SSH

  ssh_public_keys = file("${path.module}/ssh/id_terraform.pub")            # инжектим публичный ключ для SSH

  cores       = 2                                                          # CPU cores
  memory      = 2048                                                       # RAM (МБ)
  swap        = 512                                                        # swap (МБ)
  # unprivileged = true                                                     # непривилегированный режим

  rootfs {                # корневой диск
    storage = "local-lvm" # хранилище
    size    = "8G"        # размер
  }

  network {                       # сетевой интерфейс
    name     = "eth0"             # имя в контейнере
    bridge   = "vmbr0"            # мост хоста
    ip       = "192.168.31.50/24" # IP/маска
    gw       = "192.168.31.1"     # шлюз
    firewall = true               # включить фаервол Proxmox
  }

  start = true # запустить сразу

  connection { # SSH для провижинера
    type        = "ssh"
    host        = "192.168.31.50"
    user        = "root"
    private_key = file("${path.module}/ssh/id_terraform")  # используем приватный ключ для подключения
    timeout     = "2m"
  }

  provisioner "remote-exec" { # команды внутри
    inline = [
      "echo 'Контейнер запущен и готов'",
      "apt-get update",
      "apt-get install -y nginx"
    ]
  }
}
