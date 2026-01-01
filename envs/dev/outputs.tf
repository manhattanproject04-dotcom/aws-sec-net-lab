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

output "flow_logs_bucket_name" {
  value       = module.flow_logs_s3.flow_logs_bucket_name
  description = "S3 bucket receiving VPC flow logs."
}

output "flow_log_id" {
  value       = module.flow_logs_s3.flow_log_id
  description = "VPC flow log ID."
}

output "s3_gateway_endpoint_id" {
  value       = module.vpc_endpoints.s3_gateway_endpoint_id
  description = "S3 gateway VPC endpoint ID."
}

output "vpce_security_group_id" {
  value       = module.vpc_endpoints.vpce_security_group_id
  description = "Security group ID used by interface endpoints."
}

output "ssm_endpoint_ids" {
  value       = module.vpc_endpoints.ssm_endpoint_ids
  description = "SSM-related interface endpoint IDs."
}

output "private_ec2_instance_id" {
  value       = module.private_ec2_ssm.instance_id
  description = "Private EC2 instance ID managed via SSM."
}

output "private_ec2_private_ip" {
  value       = module.private_ec2_ssm.private_ip
  description = "Private EC2 instance private IP."
}

output "private_ec2_sg_id" {
  value       = module.private_ec2_ssm.instance_security_group_id
  description = "Security group ID for the private EC2 instance."
}
