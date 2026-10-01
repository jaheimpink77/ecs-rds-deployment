data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "execution" {
  name = "${var.name}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json
}

resource "aws_iam_role_policy_attachment" "execution_managed" {
  role = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "secrets_access" {
  statement {
    actions = ["secretsmanager:GetSecretValue"]
    resources = [local.db_secret]
  }
}

resource "aws_iam_role_policy" "execution_secrets" {
  name = "${var.name}-secrets-access"
  role = aws_iam_role.execution.id
  policy = data.aws_iam_policy_document.secrets_access.json
}

resource "aws_iam_role" "task" {
  name = "${var.name}-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role
}