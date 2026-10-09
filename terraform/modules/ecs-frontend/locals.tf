locals {
  image = "${data.terraform_remote_state.ecr.outputs.repository_urls["frontend"]}:${var.image_tag}"
}