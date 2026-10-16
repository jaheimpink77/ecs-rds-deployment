variable "ecr_repository_name" {
  description = "The name of the private ECR repository"
  type        = string
}
variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository"
  type        = string
}

variable "scan_on_push" {
  description = "Decides whether images pushed to the repository are scanned"
  type        = bool
}

variable "max_image_count" {
  description = "The max amount of images to keep in the ecr repository"
  type = number
  default = 20
}