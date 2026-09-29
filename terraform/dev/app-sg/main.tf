module "app_sg" {
  source = "../../modules/app-sg"

  sg_name = "ecs-rds-deployment-app-sg"
  sg_description = "The security group for the ECS app"
  container_port = 8080
}