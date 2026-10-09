module "ecr" {
  source = "../../modules/ecr"

  for_each = local.repositories

  ecr_repository_name  = each.value.ecr_repository_name
  image_tag_mutability = each.value.image_tag_mutability
  scan_on_push         = true
}