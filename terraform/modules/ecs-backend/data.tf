data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "ecs-rds-deployment-remote-state-210450948513-eu-west-2-an"
    key = "dev/vpc"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "ecr" {
  backend = "s3"
  config = {
    bucket = "ecs-rds-deployment-remote-state-210450948513-eu-west-2-an"
    key = "dev/ecr"
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

data "terraform_remote_state" "backend_sg" {
  backend = "s3"
  config = {
    bucket = "ecs-rds-deployment-remote-state-210450948513-eu-west-2-an"
    key = "dev/backend-sg"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "ecs_cluster" {
  backend = "s3"
  config = {
    bucket = "ecs-rds-deployment-remote-state-210450948513-eu-west-2-an"
    key = "dev/ecs_cluster"
    region = "eu-west-2"
  }
}

data "terraform_remote_state" "service_discovery" {
  backend = "s3"
  config = {
    bucket = "ecs-rds-deployment-remote-state-210450948513-eu-west-2-an"
    key = "dev/service-discovery"
    region = "eu-west-2"
  }
}

data "aws_region" "current" {}
