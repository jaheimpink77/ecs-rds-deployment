output "task_execution_role_arn" {
  value = module.ecs_frontend.task_execution_role_arn
}

output "service_name" {
  value = module.ecs_frontend.service_name
}

output "log_group_name" {
  value = module.ecs_frontend.log_group_name
}