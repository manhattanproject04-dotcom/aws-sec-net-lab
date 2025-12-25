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
output "admin_sg_id" {
  value       = module.security_groups.admin_sg_id
  description = "Admin security group ID."
}

output "app_sg_id" {
  value       = module.security_groups.app_sg_id
  description = "App security group ID."
}

output "data_sg_id" {
  value       = module.security_groups.data_sg_id
  description = "Data security group ID."
}
