data "terraform_remote_state" "alb" {
  backend = "s3"

  config = {
    bucket = "ecs-rds-deployment-remote-state-210450948513-eu-west-2-an"
    key = "dev/alb"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "rds" {
  backend = "s3"

  config = {
    bucket = "ecs-rds-deployment-remote-state-210450948513-eu-west-2-an"
    key = "dev/rds"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "ecs-cluster" {
  backend = "s3"

  config = {
    bucket = "ecs-rds-deployment-remote-state-210450948513-eu-west-2-an"
    key = "dev/ecs-cluster"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "ecs-backend" {
  backend = "s3"

  config = {
    bucket = "ecs-rds-deployment-remote-state-210450948513-eu-west-2-an"
    key = "dev/ecs-backend"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "ecs-frontend" {
  backend = "s3"

  config = {
    bucket = "ecs-rds-deployment-remote-state-210450948513-eu-west-2-an"
    key = "dev/ecs-frontend"
    region = "eu-west-2"
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}