module "ecs_backend" {
  source = "../../modules/ecs-backend"

  name = "ecs-rds-deployment-backend"
  container_name = "backend"
  backend_port = 8000
  image_tag = "v0.1.0"
  cpu = 256
  memory = 512
  desired_count = 1
  log_retention_days = 7
  db_name = data.terraform_remote_state.rds.db_name
}