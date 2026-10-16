output "repository_url" {
  value = aws_ecr_repository.ecs_rds_deployment.repository_url
}

output "repository_arn" {
  value = aws_ecr_repository.ecs_rds_deployment.arn
}