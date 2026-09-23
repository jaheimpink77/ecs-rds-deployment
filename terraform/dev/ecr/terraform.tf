terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"

  backend "s3" {
    bucket = "ecs-rds-deployment-remote-state-210450948513-eu-west-2-an"
    key = "dev/ecr"
    region = "eu-west-2"
  }
}

provider "aws" {
    region = "eu-west-2"
}