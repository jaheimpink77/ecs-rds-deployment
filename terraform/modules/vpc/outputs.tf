output "vpc_id" {
  value = aws_vpc.ecs_rds_deployment.id
}

output "public_subnet_ids" {
  value = [
    for subnet in aws_subnet.aws_vpc.ecs_rds_deployment : subnet.id if subnet.map_public_ip_on_launch == true
  ]
}

output "private_subnet_ids" {
  value = [
    for subnet in aws_subnet.aws_vpc.aws_vpc.ecs_rds_deployment : subnet.if if subnet.map_public_ip_on_launch == false
  ]
}