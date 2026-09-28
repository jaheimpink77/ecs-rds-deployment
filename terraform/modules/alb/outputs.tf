output "target_group_arn" {
  value = aws_lb_target_group.http.arn
}

output "lb_sg_id" {
  value = aws_security_group.lb_sg.id
}

output "lb_dns_name" {
  value = aws_lb.ecs_rds_deployment.dns_name
}

