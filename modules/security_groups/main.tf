############################################
# Security Group Patterns (least privilege)
# - admin: optional restricted ingress from CIDRs (default: none)
# - app: optional restricted ingress from CIDRs (default: none)
# - data: no public ingress; only app->data on data_port
############################################

resource "aws_security_group" "admin" {
  name        = "${var.name_prefix}-sg-admin"
  description = "Admin SG (restricted ingress; used for bastion/admin endpoints if needed)."
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-sg-admin"
    Tier = "admin"
  })
}

resource "aws_security_group" "app" {
  name        = "${var.name_prefix}-sg-app"
  description = "App SG (application tier)."
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-sg-app"
    Tier = "app"
  })
}

resource "aws_security_group" "data" {
  name        = "${var.name_prefix}-sg-data"
  description = "SecNet dev data security group"

  vpc_id = var.vpc_id

  egress = []

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-sg-data"
    Tier = "data"
  })
}

# -------------------------
# ADMIN ingress (optional)
# -------------------------
resource "aws_vpc_security_group_ingress_rule" "admin_ingress" {
  for_each = {
    for pair in setproduct(var.admin_ingress_cidrs, var.admin_ingress_ports) :
    "${pair[0]}:${pair[1]}" => { cidr = pair[0], port = pair[1] }
  }

  security_group_id = aws_security_group.admin.id
  cidr_ipv4         = each.value.cidr
  from_port         = each.value.port
  to_port           = each.value.port
  ip_protocol       = "tcp"
  description       = "Admin ingress (restricted)"
}

# Admin egress scoped to VPC CIDR (example of least privilege; adjust later if needed)
resource "aws_vpc_security_group_egress_rule" "admin_egress_vpc" {
  security_group_id = aws_security_group.admin.id
  cidr_ipv4         = var.vpc_cidr
  ip_protocol       = "-1"
  description       = "Admin egress scoped to VPC CIDR"
}

# -------------------------
# APP ingress (optional)
# -------------------------
resource "aws_vpc_security_group_ingress_rule" "app_ingress" {
  for_each = {
    for pair in setproduct(var.app_ingress_cidrs, var.app_ingress_ports) :
    "${pair[0]}:${pair[1]}" => { cidr = pair[0], port = pair[1] }
  }

  security_group_id = aws_security_group.app.id
  cidr_ipv4         = each.value.cidr
  from_port         = each.value.port
  to_port           = each.value.port
  ip_protocol       = "tcp"
  description       = "App ingress (restricted)"
}

# App -> Data (only the DB port)
resource "aws_vpc_security_group_egress_rule" "app_to_data" {
  security_group_id            = aws_security_group.app.id
  referenced_security_group_id = aws_security_group.data.id
  from_port                    = var.data_port
  to_port                      = var.data_port
  ip_protocol                  = "tcp"
  description                  = "App egress to Data (db port only)"
}

# Data <- App (only the DB port)
resource "aws_vpc_security_group_ingress_rule" "data_from_app" {
  security_group_id            = aws_security_group.data.id
  referenced_security_group_id = aws_security_group.app.id
  from_port                    = var.data_port
  to_port                      = var.data_port
  ip_protocol                  = "tcp"
  description                  = "Data ingress from App (db port only)"
}

# Data egress: deny by default (no egress rules) - strongest baseline
# Note: AWS SGs allow all egress by default unless you manage egress rules as we do here.
# Because we are using the VPC Security Group Rule resources, we are explicitly defining egress for admin/app,
# and leaving data with none to demonstrate a hard least-privilege stance.

############################################
# Security Group Patterns (least privilege)
# - admin: optional restricted ingress from CIDRs (default: none)
# - app: optional restricted ingress from CIDRs (default: none)
# - data: no public ingress; only app->data on data_port
############################################

