variable "cluster_name" {
  description = "Name of the ECS cluster"
  type = string
}

variable "name" {
  description = "Name to append onto the cloudwatch log group"
  type = string
}

variable "log_retention_days" {
  description = "Amount of days to retain log events"
  type = number
}