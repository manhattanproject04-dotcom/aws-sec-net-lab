output "vpc_id" {
  description = "ID of the created VPC."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "CIDR of the created VPC."
  value       = aws_vpc.this.cidr_block
}

output "private_subnet_ids" {
  description = "IDs of the private subnets."
  value       = [for s in aws_subnet.private : s.id]
}

output "private_route_table_id" {
  description = "ID of the private route table."
  value       = aws_route_table.private.id
}
