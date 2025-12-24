output "vpc_id" {
  value = module.network_baseline.vpc_id
}

output "private_subnet_ids" {
  value = module.network_baseline.private_subnet_ids
}

output "private_route_table_id" {
  value = module.network_baseline.private_route_table_id
}
output "public_subnet_ids" {
  value = module.network_baseline.public_subnet_ids
}

output "public_route_table_id" {
  value = module.network_baseline.public_route_table_id
}

output "internet_gateway_id" {
  value = module.network_baseline.internet_gateway_id
}
