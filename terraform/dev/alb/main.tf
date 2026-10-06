module "alb" {
  source = "../../modules/alb"
  
  vpc_name = "ecs-rds-deployment"
  lb_name = "ecs-rds-deployment-lb"
  internal = false
  load_balancer_type = "application"
  http_lb_tg_name = "http"
  http_tg_healthy_threshold = 2
  http_tg_unhealthy_threshold = 2
  http_timeout = 5
  http_interval = 10
  https_ingress_from_port = 443
  https_ingress_to_port = 443
  http_ingress_from_port = 80
  http_ingress_to_port = 80
  https_egress_from_port = 443
  https_egress_to_port = 443
  http_egress_from_port = 8080
  http_egress_to_port = 8080
  https_ingress_description = "Ingress rules for HTTPS"
  https_egress_description = "Egress rules for HTTPS"
  http_ingress_description = "Ingress rules for HTTP"
  http_egress_description = "Egress rules for HTTP"
  http_ingress_cidr_blocks = ["0.0.0.0/0"]
  https_ingress_cidr_blocks = ["0.0.0.0/0"]
  lb_sg_name = "ecs-rds-deployment-lb-sg"
  lb_sg_description = "Security group for the ecs-rds-deployment load balancer"
  revoke_rules_on_delete = true
}