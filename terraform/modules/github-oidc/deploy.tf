data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name

  service_arns = [for s in var.service_names : "arn:aws:ecs:${local.region}:${local.account_id}:service/${var.cluster_name}/${s}"]
  log_group_arns = flatten([
    for s in var.service_names : [
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/ecs/${s}:*",
      "arn:aws:logs:${local.region}:${local.account_id}:log-group:/ecs/${s}",
    ]
  ])
  role_arns      = [for s in var.service_names : "arn:aws:iam::${local.account_id}:role/${s}-*"]
  state_key_arns = [for k in var.app_state_keys : "arn:aws:s3:::${var.state_bucket}/${k}"]
  lock_key_arns  = [for k in local.state_key_arns : "${k}.tflock"]
}

## app role

data "aws_iam_policy_document" "deploy_app_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repo}:environment:${var.app_environment}"]
    }
  }
}

resource "aws_iam_role" "deploy_app" {
  name               = "${var.name}-github-deploy-app"
  assume_role_policy = data.aws_iam_policy_document.deploy_app_assume_role.json
}

data "aws_iam_policy_document" "deploy_app" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.state_bucket}"]
  }

  statement {
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.state_bucket}/dev/*"]
  }

  statement {
    actions   = ["s3:PutObject"]
    resources = concat(local.state_key_arns, local.lock_key_arns)
  }

  statement {
    actions   = ["s3:DeleteObject"]
    resources = local.lock_key_arns
  }

  statement {
    actions   = ["ecr:DescribeImages"]
    resources = var.ecr_repository_arns
  }

  statement {
    actions = [
      "ecs:RegisterTaskDefinition",
      "ecs:DeregisterTaskDefinition",
      "ecs:DescribeTaskDefinition",
      "ecs:TagResource",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ecs:UpdateService",
      "ecs:DescribeServices",
      "ecs:ListTagsForResource",
    ]
    resources = local.service_arns
  }

  statement {
    actions = [
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListRolePolicies",
      "iam:ListAttachedRolePolicies",
    ]
    resources = local.role_arns
  }

  statement {
    actions   = ["iam:PassRole"]
    resources = local.role_arns
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }

  statement {
    actions   = ["logs:DescribeLogGroups"]
    resources = ["*"]
  }
  statement {
    actions   = ["logs:ListTagsForResource", "logs:ListTagsLogGroup"]
    resources = local.log_group_arns
  }
}

resource "aws_iam_role_policy" "deploy_app" {
  name   = "deploy-app"
  role   = aws_iam_role.deploy_app.id
  policy = data.aws_iam_policy_document.deploy_app.json
}

## full role

data "aws_iam_policy_document" "deploy_full_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [for e in [var.full_environment, var.destroy_environment] : "repo:${var.github_repo}:environment:${e}"]
    }
  }
}

resource "aws_iam_role" "deploy_full" {
  name               = "${var.name}-github-deploy-full"
  assume_role_policy = data.aws_iam_policy_document.deploy_full_assume_role.json
}

resource "aws_iam_role_policy_attachment" "deploy_full_power_user" {
  role       = aws_iam_role.deploy_full.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}

data "aws_iam_policy_document" "deploy_full_iam" {
  statement {
    actions = [
      "iam:CreateRole", "iam:DeleteRole", "iam:GetRole",
      "iam:UpdateAssumeRolePolicy", "iam:TagRole", "iam:UntagRole",
      "iam:PutRolePolicy", "iam:GetRolePolicy", "iam:DeleteRolePolicy",
      "iam:ListRolePolicies", "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
    ]
    resources = local.role_arns
  }

  statement {
    actions   = ["iam:AttachRolePolicy", "iam:DetachRolePolicy"]
    resources = local.role_arns
    condition {
      test     = "ArnEquals"
      variable = "iam:PolicyARN"
      values   = ["arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"]
    }
  }

  statement {
    actions   = ["iam:PassRole"]
    resources = local.role_arns
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }

  statement {
    effect    = "Deny"
    actions   = ["s3:DeleteBucket"]
    resources = ["arn:aws:s3:::${var.state_bucket}"]
  }
}

resource "aws_iam_role_policy" "deploy_full_iam" {
  name   = "iam-scoped"
  role   = aws_iam_role.deploy_full.id
  policy = data.aws_iam_policy_document.deploy_full_iam.json
}