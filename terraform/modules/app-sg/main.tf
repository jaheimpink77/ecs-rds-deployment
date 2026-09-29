resource "aws_security_group" "app" {
  name = var.sg_name 
  description = var.sg_description
  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "from_alb" {
  security_group_id = aws_security_group.app.id
  referenced_security_group_id = data.terraform_remote_state.alb.outputs.lb_sg_id
  ip_protocol = "tcp"
  from_port = var.container_port
  to_port = var.container_port
}

resource "aws_vpc_security_group_egress_rule" "https_out" {
  security_group_id = aws_security_group.app.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port = 443
  to_port = 443
}

resource "aws_vpc_security_group_egress_rule" "postgres_out" {
  security_group_id = aws_security_group.app.id
  cidr_ipv4 = data.terraform_remote_state.vpc.outputs.vpc_cidr_block
  ip_protocol = "tcp"
  from_port = 5432
  to_port = 5432
}


