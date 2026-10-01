variable "sg_name" {
  description = "Name of the backend security group"
  type = string
}

variable "sg_description" {
  description = "Description of the backend security group"
  type = string
}

variable "backend_port" {
  description = "The backend container port which the frontend will communicate through"
  type = number
}

