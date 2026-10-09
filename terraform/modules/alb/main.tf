resource "aws_lb" "ecs_rds_deployment" {
  name               = var.lb_name
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  subnets            = data.terraform_remote_state.vpc.outputs.public_subnet_ids
  security_groups    = [aws_security_group.lb_sg.id]
}

resource "aws_lb_target_group" "http" {
  name        = var.http_lb_tg_name
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id
  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    port                = "traffic-port"
    healthy_threshold   = var.http_tg_healthy_threshold
    unhealthy_threshold = var.http_tg_unhealthy_threshold
    timeout             = var.http_timeout
    interval            = var.http_interval
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ecs_rds_deployment.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}

