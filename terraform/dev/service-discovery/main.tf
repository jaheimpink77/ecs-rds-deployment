module "service_discovery" {
  source = "../../modules/service-discovery"

  namespace_name = "ecs-rds-deployment"
}