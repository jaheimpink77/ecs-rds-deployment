output "target_group_arn" {
  value = module.alb.target_group_arn
}

output "lb_sg_id" {
  value = module.alb.lb_sg_id
}

output "lb_dns_name" {
  value = module.alb.lb_dns_name
}

output "lb_arn_suffix" {
  value = module.alb.lb_arn_suffix
}

output "target_group_arn_suffix" {
  value = module.alb.target_group_arn_suffix
}
