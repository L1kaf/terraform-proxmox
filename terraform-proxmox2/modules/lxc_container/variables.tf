variable "target_node" {}
variable "vm_hostname" {}
variable "ostemplate" {}
variable "ssh_public_key" {}
variable "private_key" {}
variable "ip_address" {}
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
