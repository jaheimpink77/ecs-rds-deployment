data "terraform_remote_state" "rds" {
  backend = "s3"

  config = {
    bucket = "ecs-rds-deployment-remote-state-210450948513-eu-west-2-an"
    key = "dev/rds"
    region = "eu-west-2"
  }
}