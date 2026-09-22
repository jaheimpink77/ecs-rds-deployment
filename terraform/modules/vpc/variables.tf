variable "vpc_cidr_block" {
  description = "The cidr block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "subnet_config" {
  description = "Map of subnet config(s), keyed by subnet name"
  type = map(object({
    cidr_block        = string
    availability_zone = string
    public            = bool
  }))

  # Every AZ's NAT gateway lives in that AZ's public subnet, so a private
  # subnet in an AZ with no public subnet would have nothing to route through.
  validation {
    condition = length([
      for name, config in var.subnet_config : name
      if !config.public && !contains(
        [for n, c in var.subnet_config : c.availability_zone if c.public],
        config.availability_zone
      )
    ]) == 0
    error_message = "Each private subnet must sit in an AZ that also has a public subnet, which hosts that AZ's NAT gateway."
  }
}