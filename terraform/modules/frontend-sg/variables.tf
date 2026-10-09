variable "sg_name" {
  description = "Name of the frontend security group"
  type        = string
}

variable "sg_description" {
  description = "Description of the frontend security group"
  type        = string
}

variable "frontend_port" {
  description = "The frontend container port which load balancer traffic will target"
  type        = number
}

variable "backend_port" {
  description = "The backend container port which the frontend container will communicate through"
  type        = number
}
