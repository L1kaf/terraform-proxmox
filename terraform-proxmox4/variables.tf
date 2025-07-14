variable "pm_token_secret" {
  description = "Секрет токена Proxmox"
}

variable "enable_monitoring" {
  type    = bool
  default = false
}
