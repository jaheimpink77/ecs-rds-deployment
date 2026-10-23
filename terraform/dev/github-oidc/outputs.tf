output "role_arn" {
  value = module.github_oidc.role_arn
}

output "deploy_app_role_arn" {
  value = module.github_oidc.deploy_app_role_arn
}

output "deploy_full_role_arn" {
  value = module.github_oidc.deploy_full_role_arn
}