resource "aws_ecr_repository" "ecs_rds_deployment" {
  name                 = var.ecr_repository_name
  image_tag_mutability = var.image_tag_mutability
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.ecs_rds_deployment.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep the most recent ${var.max_image_count} images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = var.max_image_count
      }
      action = {
        type = "expire"
      }
    }]
  })
}