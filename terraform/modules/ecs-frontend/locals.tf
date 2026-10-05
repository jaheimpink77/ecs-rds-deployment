locals {
    image = "${data.terraform_remote_state.ecr.outputs.repository_urls["frotnend"]}:${var.image_tag}"
}