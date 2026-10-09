resource "aws_security_group" "lb_sg" {
  vpc_id                 = data.terraform_remote_state.vpc.outputs.vpc_id
  name                   = var.lb_sg_name
  description            = var.lb_sg_description
  revoke_rules_on_delete = var.revoke_rules_on_delete
}

resource "aws_security_group_rule" "lb_http_ingress" {
  type              = "ingress"
  from_port         = var.http_ingress_from_port
  to_port           = var.http_ingress_to_port
  protocol          = "TCP"
  description       = var.http_ingress_description
  security_group_id = aws_security_group.lb_sg.id
  cidr_blocks       = var.http_ingress_cidr_blocks
}

resource "aws_security_group_rule" "lb_https_ingress" {
  type              = "ingress"
  from_port         = var.https_ingress_from_port
  to_port           = var.https_ingress_to_port
  protocol          = "TCP"
  description       = var.https_ingress_description
  security_group_id = aws_security_group.lb_sg.id
  cidr_blocks       = var.https_ingress_cidr_blocks
}

resource "aws_security_group_rule" "lb_http_egress" {
  type              = "egress"
  from_port         = var.http_egress_from_port
  to_port           = var.http_egress_to_port
  protocol          = "TCP"
  description       = var.http_egress_description
  security_group_id = aws_security_group.lb_sg.id
  cidr_blocks       = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
}

resource "aws_security_group_rule" "lb_https_egress" {
  type              = "egress"
  from_port         = var.https_egress_from_port
  to_port           = var.https_egress_to_port
  protocol          = "TCP"
  description       = var.https_egress_description
  security_group_id = aws_security_group.lb_sg.id
  cidr_blocks       = [data.terraform_remote_state.vpc.outputs.vpc_cidr_block]
}

