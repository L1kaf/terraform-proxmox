module "app" {
  source = "./modules/lxc_container"

  target_node     = "homeserv"
  vm_hostname     = "app-01"
  ostemplate      = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
  ssh_public_key  = file("./ssh/id_terraform.pub")
  private_key     = file("./ssh/id_terraform")
  ip_address      = "192.168.31.50/24"
  gateway         = "192.168.31.1"
  bridge          = "vmbr0"
  storage         = "Storage"
  size            = "8G"

  lxc_resources = {
    cores  = 2
    memory = 2048
    swap   = 512
  }

}


output "container_hostname" {
  value = module.app.vm_hostname
}
