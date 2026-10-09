module "frontend_sg" {
  source = "../../modules/frontend-sg"

  sg_name        = "ecs-rds-deployment-frontend-sg"
  sg_description = "The security group for the ECS frontend service"
  frontend_port  = 8080
  backend_port   = 8000
}