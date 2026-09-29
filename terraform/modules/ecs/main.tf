resource "aws_ecs_cluster" "ecs_rds_deployment" {
  name = var.cluster_name
}

resource "aws_cloudwatch_log_group" "app" {
  name = "/ecs/${var.name}"
  retention_in_days = var.log_retention_days
}