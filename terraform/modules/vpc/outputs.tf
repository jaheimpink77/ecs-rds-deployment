output "vpc_id" {
  value = aws_vpc.ecs_rds_deployment.id
}

output "public_subnet_ids" {
  value = [
    for subnet in aws_subnet.aws_vpc.ecs_rds_deployment : subnet.id if subnet.tags.Name == "public"
  ]
}