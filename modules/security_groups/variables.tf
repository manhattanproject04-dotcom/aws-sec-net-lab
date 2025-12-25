variable "name_prefix" {
  description = "Prefix used for naming/tagging resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to attach security groups to."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block (used for scoped egress where appropriate)."
  type        = string
}

variable "admin_ingress_cidrs" {
  description = "Optional CIDRs allowed to reach admin endpoints (e.g., your public IP /32). Empty by default."
  type        = list(string)
  default     = []
}

variable "admin_ingress_ports" {
  description = "Optional admin ingress ports (e.g., 22 for SSH, 3389 for RDP)."
  type        = list(number)
  default     = [22]
}

variable "app_ingress_cidrs" {
  description = "Optional CIDRs allowed to reach app endpoints. Keep empty unless you intentionally expose."
  type        = list(string)
  default     = []
}

variable "app_ingress_ports" {
  description = "Optional app ingress ports (e.g., 80/443)."
  type        = list(number)
  default     = [443]
}

variable "data_port" {
  description = "Database/listener port allowed from app -> data."
  type        = number
  default     = 5432
}

variable "tags" {
  description = "Common tags to apply."
  type        = map(string)
  default     = {}
}
