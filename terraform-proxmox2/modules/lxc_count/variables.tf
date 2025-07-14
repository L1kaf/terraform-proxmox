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

variable "vm_count" {
  description = "Сколько контейнеров создать"
  type        = number
  default     = 2
}
