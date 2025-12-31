variable "name_prefix" {
  type        = string
  description = "Prefix for naming resources."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to enable flow logs on."
}

variable "region" {
  type        = string
  description = "AWS region."
  default     = "us-east-2"
}

variable "log_retention_days" {
  type        = number
  description = "S3 lifecycle expiration in days for flow logs."
  default     = 14
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
  default     = {}
}
