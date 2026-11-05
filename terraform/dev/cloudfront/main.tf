module "cloudfront" {
  source = "../../modules/cloudfront"

  name               = var.name
  origin_domain_name = data.terraform_remote_state.alb.outputs.lb_dns_name
}