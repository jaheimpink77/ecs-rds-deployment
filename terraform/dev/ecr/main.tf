module "ecr" {
    source = "../../modules/ecr"

    ecr_repository_name = "ecs-rds-deployment"
    image_tag_mutability = "IMMUTABLE"
    scan_on_push = true
}