output "vpc_id" {
  value = aws_vpc.ecs_rds_deployment.id
}

output "public_subnet_ids" {
  value = [
    for name in key(local.public_subnets) : aws_subnet.aws_vpc.ecs_rds_deployment[name].id
  ]
}

output "private_subnet_ids" {
  value = [
    for name in key(local.private_subnets) : aws_subnet.aws_vpc.ecs_rds_deployment[name].id
  ]
}