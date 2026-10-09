locals {
  repositories = {
    backend = {
      ecr_repository_name  = "ecs-rds-deployment-backend"
      image_tag_mutability = "IMMUTABLE"
      scan_on_push         = true
    }
    frontend = {
      ecr_repository_name  = "ecs-rds-deployment-frontend"
      image_tag_mutability = "IMMUTABLE"
      scan_on_push         = true
    }
  }
}