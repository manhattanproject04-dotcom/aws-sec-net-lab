# Latest Amazon Linux 2023 AMI (x86_64)
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# IAM role assumed by EC2
resource "aws_iam_role" "ssm_instance_role" {
  name = "${var.name_prefix}-role-ssm-instance"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-role-ssm-instance"
  })
}

# Attach AWS-managed SSM core permissions
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ssm_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${var.name_prefix}-ip-ssm-instance"
  role = aws_iam_role.ssm_instance_role.name
}

# Security Group: no ingress; minimal egress for SSM + DNS
resource "aws_security_group" "private_instance" {
  name        = "${var.name_prefix}-sg-private-ec2"
  description = "Private EC2 managed via SSM (no SSH, no inbound)."
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-sg-private-ec2"
  })
}

# HTTPS egress (SSM + endpoints)
resource "aws_vpc_security_group_egress_rule" "https" {
  security_group_id = aws_security_group.private_instance.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow HTTPS egress (SSM via interface endpoints; S3 via gateway endpoint)."
}

# DNS egress (VPC resolver)
resource "aws_vpc_security_group_egress_rule" "dns_udp" {
  security_group_id = aws_security_group.private_instance.id
  ip_protocol       = "udp"
  from_port         = 53
  to_port           = 53
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow DNS (UDP)."
}

resource "aws_vpc_security_group_egress_rule" "dns_tcp" {
  security_group_id = aws_security_group.private_instance.id
  ip_protocol       = "tcp"
  from_port         = 53
  to_port           = 53
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow DNS (TCP)."
}

resource "aws_instance" "private" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [aws_security_group.private_instance.id]
  iam_instance_profile        = aws_iam_instance_profile.ssm_instance_profile.name
  associate_public_ip_address = false

  metadata_options {
    http_tokens = "required" # IMDSv2
  }

  root_block_device {
    encrypted = true
  }

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-private-ec2-ssm"
  })
}
