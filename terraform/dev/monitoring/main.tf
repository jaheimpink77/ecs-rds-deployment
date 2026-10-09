module "monitoring" {
  source = "../../modules/monitoring"

  name        = "ecs-rds-deployment"
  alert_email = var.alert_email
}