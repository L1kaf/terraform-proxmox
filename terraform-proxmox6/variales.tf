variable "pm_token_secret" {
  description = "Секрет токена Proxmox"
}
variable "containers" {
  type = map(object({
    ip     = string
    memory = number
    ssh    = string
  }))
  default = {
    app01 = {
      ip     = "192.168.31.60"
      memory = 1024
      ssh    = "" # Пустое значение, так как будем загружать ключи в main.tf
    },
    app02 = {
      ip     = "192.168.31.61"
      memory = 2048
      ssh    = "" # Пустое значение, так как будем загружать ключи в main.tf
    }
  }
}
