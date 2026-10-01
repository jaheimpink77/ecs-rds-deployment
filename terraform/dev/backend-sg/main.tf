module "backend_sg" {
  source = "../../modules/backend-sg"

  sg_name = "ecs-rds-deployment-backend-sg"
  sg_description = "The security group for the ECS backend service"
  backend_port = 8000
}