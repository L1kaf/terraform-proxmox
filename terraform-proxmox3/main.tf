module "db" {
  source = "./modules/db"
  db_ip  = "192.168.31.201/24"
}

module "app" {
  source  = "./modules/app"
  db_host = module.db.db_ip
}

output "db_ip_for_app" {
  value = module.db.db_ip
}
