variable "name_prefix" {
  description = "Prefix used for naming/tagging resources."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC (e.g., 10.10.0.0/16)."
  type        = string
}

variable "availability_zones" {
  description = "Two AZ names to place private subnets into (e.g., [\"us-east-2a\",\"us-east-2b\"])."
  type        = list(string)

  validation {
    condition     = length(var.availability_zones) == 2
    error_message = "availability_zones must contain exactly 2 AZs."
  }
}

variable "tags" {
  description = "Common tags to apply to resources."
  type        = map(string)
  default     = {}
}
