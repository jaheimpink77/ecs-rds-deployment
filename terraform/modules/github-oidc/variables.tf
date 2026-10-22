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

variable "state_bucket" {
  description = "Name of the S3 bucket holding Terraform state"
  type        = string
}

variable "cluster_name" {
  description = "ECS cluster the app deploy role may update service in"
  type        = string
}

variable "service_names" {
  description = "ECS service names (also task definition families and role name prefix)"
  type        = list(string)
}

variable "app_state_keys" {
  description = "State keys the app deploy role may write, e.g. dev/ecs-backend"
  type        = list(string)
}

variable "app_environment" {
  description = "GitHub Environment whose jobs may assume the app deploy role"
  type        = string
  default     = "dev-app"
}

variable "full_environment" {
  description = "GitHub Environment whose jobs may assume the full deploy role"
  type        = string
  default     = "dev-full"
}