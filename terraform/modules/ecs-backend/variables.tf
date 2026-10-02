variable "name" {
  description = "Name of resources created with the ecs_backend module"
  type = string
}

variable "container_name" {
  description = "Name of the backend container"
  type = string
}

variable "backend_port" {
  description = "Port number for the backend container"
  type = number
}

variable "image_tag" {
  description = "Tag of the backend container's image to use"
  type = string
}

variable "cpu" {
  description = "Amount of CPU to assign to the backend task"
  type = string
}

variable "memory" {
  description = "Amount of memory to assign to the backend task"
  type = string
}

variable "desired_count" {
  description = "Number of instances of the backend task definition"
  type = string
}

variable "log_retention_days" {
  description = "Number of days to retain logs in cloudwatch"
  type = number
}

variable "db_name" {
  description = "Name of the DB that the backend task will communicate with"
  type = string
}