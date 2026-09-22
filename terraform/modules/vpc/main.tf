resource "aws_vpc" "ecs_rds_deployment" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "ecs_rds_deployment" {
  for_each = var.subnet_config

  vpc_id            = aws_vpc.ecs_rds_deployment.id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  map_public_ip_on_launch = each.value.public

  tags = {
    Name = each.key
  }
}

resource "aws_internet_gateway" "ecs_rds_deployment" {
  vpc_id = aws_vpc.ecs_rds_deployment.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}


resource "aws_eip" "nat" {
  for_each = local.public_subnet_by_az

  domain = "vpc"

  tags = {
    Name = "${var.vpc_name}-nat-${each.key}"
  }
}

# One NAT gateway per AZ, placed in that AZ's public subnet. each.key is the AZ,
# each.value is the name of the public subnet hosting it.
resource "aws_nat_gateway" "ecs_rds_deployment" {
  for_each = local.public_subnet_by_az

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.ecs_rds_deployment[each.value].id

  depends_on = [aws_internet_gateway.ecs_rds_deployment]

  tags = {
    Name = "${var.vpc_name}-nat-${each.key}"
  }
}

# One private route table per AZ, pointing at that AZ's NAT gateway.
resource "aws_route_table" "private" {
  for_each = local.public_subnet_by_az

  vpc_id = aws_vpc.ecs_rds_deployment.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ecs_rds_deployment[each.key].id
  }

  tags = {
    Name = "${var.vpc_name}-private-${each.key}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.ecs_rds_deployment.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_rds_deployment.id
  }

  tags = {
    Name = "${var.vpc_name}-public"
  }
}

resource "aws_route_table_association" "public" {
  for_each = local.public_subnets

  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.ecs_rds_deployment[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each = local.private_subnets

  route_table_id = aws_route_table.private[each.value.availability_zone].id
  subnet_id      = aws_subnet.ecs_rds_deployment[each.key].id
}