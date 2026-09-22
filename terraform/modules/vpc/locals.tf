locals {
  public_subnets  = { for name, config in var.subnet_config : name => config if config.public }
  private_subnets = { for name, config in var.subnet_config : name => config if !config.public }

  public_subnet_by_az = {
    for az, names in { for name, config in local.public_subnets : config.availability_zone => name... } :
    az => sort(names)[0]
  }
}