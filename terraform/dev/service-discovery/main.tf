module "service_disvocery" {
  source = "../../modules/service-discovery"

  namespace_name = "ecs-rds-deployment"
}