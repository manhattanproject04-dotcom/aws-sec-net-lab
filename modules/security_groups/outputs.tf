output "admin_sg_id" {
  value       = aws_security_group.admin.id
  description = "Admin security group ID."
}

output "app_sg_id" {
  value       = aws_security_group.app.id
  description = "App security group ID."
}

output "data_sg_id" {
  value       = aws_security_group.data.id
  description = "Data security group ID."
}
