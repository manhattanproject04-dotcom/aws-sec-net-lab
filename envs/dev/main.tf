module "network_baseline" {
  source = "../../modules/network_baseline"

  name_prefix        = var.name_prefix
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  tags               = var.tags
}
