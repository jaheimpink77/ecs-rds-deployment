output "role_arn" {
  value = aws_iam_role.ecr_push.arn
}
output "deploy_app_role_arn" {
  value = aws_iam_role.deploy_app.arn
}

output "deploy_full_role_arn" {
  value = aws_iam_role.deploy_full.arn
}