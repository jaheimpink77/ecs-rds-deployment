variable "sg_name" {
  description = "Name of the app security group"
  type = string
}

variable "sg_description" {
  description = "Description of the app security group"
  type = string
}

variable "container_port" {
  description = "The container port which load balancer traffic will target"
  type = number
}
