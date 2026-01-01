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

variable "private_subnet_id" {
  type        = string
  description = "Subnet ID for the private instance."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
  default     = "t3.micro"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
  default     = {}
}
