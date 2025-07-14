locals {
  names = ["frontend", "backend", "db"]
  env   = "prod"
}

locals {
  full_names = [for name in local.names : format("%s-%s", name, local.env)]
}

output "joined_names" {
  value = join(", ", local.full_names)
}

output "selected" {
  value = var.images["ru-central"]
}


locals {
  base = { cpu = 1, mem = 512 }
  extra = { mem = 1024, disk = 20 }

  result = merge(local.base, local.extra)
}

output "merged" {
  value = local.result
}

locals {
  memory = var.environment == "prod" ? 2048 : 1024
}

output "memory_size" {
  value = local.memory
}

output "web_memory" {
  value = lookup(var.lxc_configs["web"], "memory", 512)
}

output "disk_size" {
  value = try(var.custom_config.disk, 10)
}
