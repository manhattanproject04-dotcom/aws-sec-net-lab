variable "name_prefix" {
  type        = string
  description = "Prefix for naming resources."
}

variable "region" {
  type        = string
  description = "AWS region."
  default     = "us-east-2"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID."
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR, used to allow HTTPS to interface endpoints."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs to place interface endpoints in."
}

variable "private_route_table_id" {
  type        = string
  description = "Private route table ID for the S3 gateway endpoint association."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
  default     = {}
}

variable "enable_ssm_endpoints" {
  type        = bool
  description = "Whether to create SSM-related interface endpoints."
  default     = true
}
