module "budget" {
  source = "../../modules/budget"

  name         = "ecs-rds-deployment"
  alert_email  = var.alert_email
  limit_amount = var.limit_amount
}