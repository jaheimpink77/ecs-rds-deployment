module "github_oidc" {
  source = "../../modules/github-oidc"

  name                = "ecs-rds-deployment"
  github_repo         = "jaheimpink77/ecs-rds-deployment"
  ecr_repository_arns = values(data.terraform_remote_state.ecr.outputs.repository_arns)
}