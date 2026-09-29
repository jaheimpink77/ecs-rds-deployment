module "ecs" {
  source = "../../modules/ecs"

  cluster_name = "ecs-rds-deployment-cluster"
  name = "app"
  log_retention_days = 1
}