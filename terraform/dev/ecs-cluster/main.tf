module "ecs_cluster" {
  source = "../../modules/ecs-cluster"

  cluster_name = "ecs-rds-deplyment"
}