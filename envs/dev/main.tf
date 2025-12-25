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
