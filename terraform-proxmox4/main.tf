module "monitoring" {
  count  = var.enable_monitoring ? 1 : 0
  source = "./modules/monitoring"

  prometheus_ip = "192.168.31.99/24"
}
