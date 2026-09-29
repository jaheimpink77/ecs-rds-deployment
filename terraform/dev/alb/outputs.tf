output "target_group_arn" {
  value = module.alb.target_group_arn
}

output "lb_sg_id" {
  value = module.alb.lb_sg_id
}

output "lb_dns_name" {
  value = module.alb.lb_dns_name
}