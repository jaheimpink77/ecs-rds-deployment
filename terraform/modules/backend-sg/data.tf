data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "ecs-rds-deployment-remote-state-210450948513-eu-west-2-an"
    key    = "dev/vpc"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "frontend_sg" {
  backend = "s3"
  config = {
    bucket = "ecs-rds-deployment-remote-state-210450948513-eu-west-2-an"
    key    = "dev/frontend-sg"
    region = "eu-west-2"
  }
}