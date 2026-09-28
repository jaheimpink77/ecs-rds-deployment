resource "aws_db_subnet_group" "database_subnet_group" {
  name = "${var.name}-subnet-group"
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnet_ids
  description = "Subnets for database instance"
}

resource "aws_security_group" "rds" {
  name_prefix = "${var.name}-rds-"
  vpc_id = data.terraform_remote_state.vpc.vpc_id
}

resource "aws_vpc_security_group_ingress_rule" "from_app" {
  security_group_id = aws_security_group.rds.id
  referenced_security_group_id = data.terraform_remote_state.ecs.outputs.sg_id
  ip_protocol = "tcp"
  from_port = 5432
  to_port = 5432
}

resource "aws_db_instance" "this" {
  identifier = "${var.name}-db"
  engine = "postgres"
  engine_version = "16"
  instance_class = "db.t4g.micro"

  allocated_storage = 20
  storage_encrypted = true

  db_name = "appdb"
  username = "appuser"

  manage_master_user_password = true

  db_subnet_group_name = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible = false
  multi_az = false

  backup_retention_period = 1
  skip_final_snapshot = true
}