locals {
    image = "${data.terraform_remote_state.ecr.outputs.repository_url}:${var.image_tag}"
}