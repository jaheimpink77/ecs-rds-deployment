locals {
  lb_suffix         = data.terraform_remote_state.alb.outputs.lb_arn_suffix
  tg_suffix         = data.terraform_remote_state.alb.outputs.target_group_arn_suffix
  db_id             = data.terraform_remote_state.rds.outputs.db_identifier
  cluster_name      = data.terraform_remote_state.ecs_cluster.outputs.cluster_name
  backend_log_group = data.terraform_remote_state.ecs_backend.outputs.log_group_name
  region            = data.aws_region.current.name
  account_id        = data.aws_caller_identity.current.account_id
  cluster_arn       = data.terraform_remote_state.ecs_cluster.outputs.cluster_arn
  ecs_services = {
    backend  = data.terraform_remote_state.ecs_backend.outputs.service_name
    frontend = data.terraform_remote_state.ecs_frontend.outputs.service_name
  }
}