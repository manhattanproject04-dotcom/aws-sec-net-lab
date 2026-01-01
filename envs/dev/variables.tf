variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-2"
}

variable "aws_profile" {
  description = "AWS CLI profile name Terraform should use."
  type        = string
  default     = "lab"
}

variable "name_prefix" {
  description = "Prefix used for naming/tagging resources."
  type        = string
  default     = "secnet-dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "Two AZ names for private subnets."
  type        = list(string)
}

variable "tags" {
  description = "Common tags to apply."
  type        = map(string)
  default     = {}
}

variable "region" {
  type        = string
  description = "AWS region for this environment."
  default     = "us-east-2"
}
