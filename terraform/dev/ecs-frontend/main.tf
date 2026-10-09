module "ecs_frontend" {
  source = "../../modules/ecs-frontend"

  name                              = "ecs-rds-deployment-frontend"
  container_name                    = "frontend"
  frontend_port                     = 8080
  backend_port                      = 8000
  image_tag                         = "v0.1.0"
  cpu                               = 256
  memory                            = 512
  desired_count                     = 1
  log_retention_days                = 7
  health_check_grace_period_seconds = 60
}