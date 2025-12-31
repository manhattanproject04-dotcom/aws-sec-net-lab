output "instance_id" {
  value       = aws_instance.private.id
  description = "Private EC2 instance ID."
}

output "private_ip" {
  value       = aws_instance.private.private_ip
  description = "Private IP address."
}

output "instance_security_group_id" {
  value       = aws_security_group.private_instance.id
  description = "Security group ID for the private instance."
}

output "instance_role_name" {
  value       = aws_iam_role.ssm_instance_role.name
  description = "IAM role name attached to the instance."
}

output "instance_profile_name" {
  value       = aws_iam_instance_profile.ssm_instance_profile.name
  description = "IAM instance profile name attached to the instance."
}
