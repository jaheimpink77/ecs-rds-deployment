locals {
  image     = "${data.terraform_remote_state.ecr.outputs.repository_urls["backend"]}:${var.image_tag}"
  db_secret = data.terraform_remote_state.rds.outputs.secret_arn
}