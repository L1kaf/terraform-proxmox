terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = ">= 1.0.0"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure     = true
  pm_api_url          = var.pm_url
  pm_api_token_secret = var.pm_token
  pm_api_token_id     = var.pm_user
}
