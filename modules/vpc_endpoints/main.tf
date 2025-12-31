locals {
  s3_service_name   = "com.amazonaws.${var.region}.s3"
  ssm_service_name  = "com.amazonaws.${var.region}.ssm"
  ec2m_service_name = "com.amazonaws.${var.region}.ec2messages"
  ssmm_service_name = "com.amazonaws.${var.region}.ssmmessages"
}

# Gateway endpoint for S3 (no ENIs, no hourly costs)
resource "aws_vpc_endpoint" "s3_gateway" {
  vpc_id            = var.vpc_id
  service_name      = local.s3_service_name
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [var.private_route_table_id]

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-vpce-s3-gateway"
  })
}

# Security group for interface endpoints (HTTPS from inside VPC)
resource "aws_security_group" "vpce" {
  name        = "${var.name_prefix}-sg-vpce"
  description = "Security group for VPC interface endpoints (HTTPS)."
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTPS from within VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Allow all egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-sg-vpce"
  })
}

resource "aws_vpc_endpoint" "ssm" {
  count               = var.enable_ssm_endpoints ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = local.ssm_service_name
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-vpce-ssm"
  })
}

resource "aws_vpc_endpoint" "ec2messages" {
  count               = var.enable_ssm_endpoints ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = local.ec2m_service_name
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-vpce-ec2messages"
  })
}

resource "aws_vpc_endpoint" "ssmmessages" {
  count               = var.enable_ssm_endpoints ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = local.ssmm_service_name
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.private_subnet_ids
  security_group_ids  = [aws_security_group.vpce.id]
  private_dns_enabled = true

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-vpce-ssmmessages"
  })
}
