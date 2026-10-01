resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/${var.name}"
  retention_in_days = var.log_retention_days
}

resource "aws_ecs_task_definition" "this" {
  family = var.name
  requires_compatibilities = ["FARGATE"]
  network_mode = "awsvpc"
  cpu = var.cpu
  memory = var.memory
  execution_role_arn = aws_iam_role.execution.arn
  task_role_arn = aws_iam_role.task.arn

  container_definitions = jsonencode([{
    name = var.container_name
    image = local.image
    essential = true

    portMappings = [{
      name = var.container_name
      containerPort = var.backend_port
      protocol = "tcp"
    }]

    environment = [
      { name = "DB_HOST", value = data.terraform_remote_state.rds.outputs.endpoint},
      { name = "DB_NAME", value = var.db_name},
    ]

    secrets = [
      { name = "DB_USER", valueFrom = "${local.db_secret}:username::" },
      { name = "DB_PASSWORD", valueFrom = "${local.db_secret}:password::"},
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group = aws_cloudwatch_log_group.this.name
        awslogs-region = data.aws_region.current.name
        awslogs-stream-prefix = var.name
      }
    }
  }])
}

resource "aws_ecs_service" "this" {
  name = var.name
  cluster = data.terraform_remote_state.ecs_cluster.outputs.cluster_id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count = var.desired_count
  launch_type = "FARGATE"

  network_configuration {
    subnets = data.terraform_remote_state.vpc.outputs.private_subnet_ids
    security_groups = [data.terraform_remote_state.backend_sg.outputs.sg_id]
    assign_public_ip = false
  }

  service_connect_configuration {
    enabled = true
    namespace = data.terraform_remote_state.service_discovery.outputs.namespace_arn

    service {
      port_name = var.container_name
      discovery_name = "backend"

    }
  }
}