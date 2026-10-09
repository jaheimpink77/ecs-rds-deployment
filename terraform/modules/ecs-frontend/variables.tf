variable "name" {
  description = "Name of the resources created with the ecs-frontend module"
  type        = string
}

variable "container_name" {
  description = "Name of the forntend container"
  type        = string
}

variable "frontend_port" {
  description = "Number of the frontend conteainer port"
  type        = number
}

variable "backend_port" {
  description = "Number of the backend container port"
  type        = number
}

variable "image_tag" {
  description = "Image tag of the frontend container image"
  type        = string
}

variable "cpu" {
  description = "Amount of CPU to assign to the frontend task"
  type        = number
}

variable "memory" {
  description = "Amount of memeory to assign to the frontend task"
  type        = number
}

variable "desired_count" {
  description = "Number of instances of the frontend task"
  type        = number
}

variable "log_retention_days" {
  description = "Amount of days that CloudWatch logs for the frontend task should be retained for"
  type        = number
}

variable "health_check_grace_period_seconds" {
  description = "Amount of time in seconds to ignore failing load balancer healtchecks"
  type        = number
}