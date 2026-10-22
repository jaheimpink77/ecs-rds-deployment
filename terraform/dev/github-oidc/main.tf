module "github_oidc" {
  source = "../../modules/github-oidc"

  name                = "ecs-rds-deployment"
  github_repo         = "jaheimpink77@273834348/ecs-rds-deployment@1372953712"
  ecr_repository_arns = values(data.terraform_remote_state.ecr.outputs.repository_arns)

  state_bucket   = "ecs-rds-deployment-remote-state-210450948513-eu-west-2-an"
  cluster_name   = "ecs-rds-deployment"
  service_names  = ["ecs-rds-deployment-backend", "ecs-rds-deployment-frontend"]
  app_state_keys = ["dev/ecs-backend", "dev/ecs-frontend"]
}