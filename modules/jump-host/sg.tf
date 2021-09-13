resource "aws_security_group" "default" {
  name        = "${var.name}-sg"
  vpc_id      = var.vpc_id
  description = "Instance default security group (only egress access is allowed)"
  tags = {
    Name       = var.name
    managed_by = "terraform"
    project    = "greg-tr-eks"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "egress" {
  count             = var.create_default_security_group ? 1 : 0
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}

resource "aws_security_group_rule" "ingress" {
  count             = var.create_default_security_group ? 1 : 0
  type              = "ingress"
  from_port         = var.allowed_port
  to_port           = var.allowed_port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.default.id
}