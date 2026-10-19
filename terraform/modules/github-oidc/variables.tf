variable "name" {
  description = "Name of the resources created with the github-oidc module"
  type        = string
}

variable "github_repo" {
  description = "The github repo identifier as it appears in the OIDC sub cliam. including the owner and repo IDs"
  type        = string
}

variable "allowed_ref" {
  description = "The branch ref that can use the OIDC provider"
  type        = string
  default     = "refs/heads/master"
}

variable "ecr_repository_arns" {
  description = "The ECR repository arns that the role can perform actions against"
  type        = list(string)
}
