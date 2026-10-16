variable "name" {
  description = "Name of the resources created with the github-oidc module"
  type = string
}

variable "github_repo" {
  description = "The github repo that can use the OIDC provider"
  type = string
  default = "jaheimpink77/ecs-rds-deployment"
}

variable "allowed_ref" {
  description = "The branch ref that can use the OIDC provider"
  type = string
  default = "refs/heads/master"
}

variable "ecr_repository_arns" {
  description = "The ECR repository arns that the role can perform actions against"
  type = list(string)
}
