variable "target_node" {}
variable "ostemplate" {}
variable "ssh_public_key" {}
variable "private_key" {}
variable "gateway" {}
variable "bridge" {}
variable "storage" {}
variable "size" {}

variable "lxc_resources" {
  type = object({
    cores  = number
    memory = number
    swap   = number
  })
}

variable "lxc_map" {
  default = {
    web01 = { ip = "192.168.31.201/24" }
    web02 = { ip = "192.168.31.202/24" }
  }
}
