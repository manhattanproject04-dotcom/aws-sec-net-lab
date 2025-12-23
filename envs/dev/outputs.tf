output "vpc_id" {
  value = module.network_baseline.vpc_id
}

output "private_subnet_ids" {
  value = module.network_baseline.private_subnet_ids
}

output "private_route_table_id" {
  value = module.network_baseline.private_route_table_id
}
