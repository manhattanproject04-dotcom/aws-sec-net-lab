module "network_baseline" {
  source = "../../modules/network_baseline"

  name_prefix        = var.name_prefix
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  tags               = var.tags
}
module "security_groups" {
  source = "../../modules/security_groups"

  name_prefix = var.name_prefix
  vpc_id      = module.network_baseline.vpc_id
  vpc_cidr    = module.network_baseline.vpc_cidr
  tags        = var.tags

  # Closed-by-default; set later when you want to test ingress.
  admin_ingress_cidrs = []
  app_ingress_cidrs   = []
}

module "flow_logs_s3" {
  source = "../../modules/flow_logs_s3"

  name_prefix        = var.name_prefix
  vpc_id             = module.network_baseline.vpc_id
  region             = "us-east-2"
  log_retention_days = 14
  tags               = var.tags
}

module "vpc_endpoints" {
  source = "../../modules/vpc_endpoints"

  name_prefix            = var.name_prefix
  region                 = var.region
  vpc_id                 = module.network_baseline.vpc_id
  vpc_cidr               = module.network_baseline.vpc_cidr
  private_subnet_ids     = module.network_baseline.private_subnet_ids
  private_route_table_id = module.network_baseline.private_route_table_id
  tags                   = var.tags

  enable_ssm_endpoints = true
}

module "private_ec2_ssm" {
  source = "../../modules/private_ec2_ssm"

  name_prefix       = var.name_prefix
  region            = var.region
  vpc_id            = module.network_baseline.vpc_id
  private_subnet_id = module.network_baseline.private_subnet_ids[0]
  tags              = var.tags
}
