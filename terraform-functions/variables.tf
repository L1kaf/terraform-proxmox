variable "images" {
  default = {
    ru-central = "img-001"
    us-west    = "img-002"
  }
}

variable "environment" {
  default = "dev"
}

variable "lxc_configs" {
  default = {
    web = { memory = 1024 }
  }
}

variable "custom_config" {
  default = {}
}
