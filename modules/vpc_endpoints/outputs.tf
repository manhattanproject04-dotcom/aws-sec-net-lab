output "s3_gateway_endpoint_id" {
  value       = aws_vpc_endpoint.s3_gateway.id
  description = "S3 gateway VPC endpoint ID."
}

output "vpce_security_group_id" {
  value       = aws_security_group.vpce.id
  description = "Security group ID used by interface endpoints."
}

output "ssm_endpoint_ids" {
  value = {
    ssm         = try(aws_vpc_endpoint.ssm[0].id, null)
    ec2messages = try(aws_vpc_endpoint.ec2messages[0].id, null)
    ssmmessages = try(aws_vpc_endpoint.ssmmessages[0].id, null)
  }
  description = "Map of SSM-related interface endpoint IDs."
}
