data "terraform_remote_state" "alb" {
  backend = "s3"

  config = {
    bucket = "ecs-rds-deployment-remote-state-210450948513-eu-west-2-an"
    key    = "dev/alb"
    region = "eu-west-2"
  }
}