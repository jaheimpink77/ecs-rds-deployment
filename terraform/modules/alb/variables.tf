## data.tf variables

variable "vpc_name" {
  description = "Name of the VPC"
  type = string
}

## main.tf variables
variable "lb_name" {
  description = "Name of the load balancer"
  type = string
}

variable "internal" {
  description = "Decides whther the lb is internal"
  type = bool
}

variable "load_balancer_type" {
  description = "The type of load balancer to create"
  type = string
}

variable "http_lb_tg_name" {
  description = "The name of the lb tg"
  type = string
}

variable "http_tg_healthy_threshold" {
  description = "Number of consecutive health check successes required before considering a target healthy for the http tg"
  type = number
}

variable "http_tg_unhealthy_threshold" {
  description = "Number of consecutive health check failures required before considering a target unhealthy"
  type = number
}

variable "http_timeout" {
  description = "Amount of time in seconds during which no response from a target means a failed healthcheck for the http tg"
  type = number
}

variable "http_interval" {
  description = "Approximate amount of time in seconds between healtchecks for the http tg"
  type = number
}

## sg.tf variables

variable "https_ingress_from_port" {
  description = "Start port for https ingress sg rule"
  type = number
}

variable "https_ingress_to_port" {
  description = "End port for https ingress sg rule"
  type = number
}

variable "http_ingress_from_port" {
  description = "Start port for http ingress sg rule"
  type = number
}

variable "http_ingress_to_port" {
  description = "End port for http ingress sg rule"
  type = number
}

variable "https_egress_from_port" {
  description = "Start port for https egress sg rule"
  type = number
}

variable "https_egress_to_port" {
  description = "End port for https egress sg rule"
  type = number
}

variable "http_egress_from_port" {
  description = "Start port for http egress dg rule"
  type = number
}

variable "http_egress_to_port" {
  description = "End port for http egress sg rule"
  type = number
}

variable "https_ingress_description" {
  description = "Description for https ingress sg rule"
  type = string
}

variable "http_ingress_description" {
  description = "Description for http ingress sg rule"
  type = string
}

variable "https_egress_description" {
  description = "Description for https egress sg rule"
  type = string
}

variable "http_egress_description" {
  description = "Description for http egress sg rule"
  type = string
}

variable "http_ingress_cidr_blocks" {
  description = "CIDR blocks for http ingress sg rule"
  type = list(string)
}

variable "https_ingress_cidr_blocks" {
  description = "CIDR blocks for https ingress sg rule"
  type = list(string)
}

variable "http_egress_cidr_blocks" {
  description = "CIDR blocks for http egress sg rule"
  type = list(string)
}

variable "https_egress_cidr_blocks" {
  description = "CIDR blocks for https egress sg rule"
  type = list(string)
}

variable "lb_sg_name" {
  description = "Name of the lb sg"
  type = string
}

variable "lb_sg_description" {
  description = "Description of the lb sg"
  type = string
}

variable "revoke_rules_on_delete" {
  description = "Decides whether to revoke all of the attached ingress and egress rules before delting the rule itself"
  type = bool
}

