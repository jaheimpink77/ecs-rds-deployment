module "vpc" {
  source = "../../modules/vpc"

  vpc_cidr_block = "10.0.0.0/16"
  vpc_name       = "ecs-rd-deployment"
  subnet_config = {
    public_subnet_1 = {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "eu-west-2a"
      public            = true
    },
    public_subnet_2 = {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "eu-west-2b"
      public            = true
    },
    private_subnet_1 = {
      cidr_block        = "10.0.3.0/24"
      availability_zone = "eu-west-2a"
      public            = false
    },
    private_subnet_2 = {
      cidr_block        = "10.0.4.0/24"
      availability_zone = "eu-west-2b"
      public            = false
    }
  }
}

