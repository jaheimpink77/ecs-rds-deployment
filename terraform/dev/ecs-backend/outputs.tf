output "task_execution_role_arn" {
  value = module.ecs_backend.task_execution_role_arn
}

output "service_name" {
  value = module.ecs_backend.service_name
}

output "log_group_name" {
  value = module.ecs_backend.log_group_name
}