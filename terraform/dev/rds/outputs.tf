output "secret_arn" {
  value = module.rds.secret_arn
}

output "endpoint" {
  value = module.rds.endpoint
}

output "db_name" {
  value = module.rds.db_name
}