variable "endpoint" {
  description = "URL Proxmox API"
  type        = string
}

variable "api_token" {
  description = "API-токен в формате ID=VALUE"
  type        = string
  sensitive   = true
}
