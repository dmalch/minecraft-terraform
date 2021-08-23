module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "minecraft-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  # Single NAT Gateway
  enable_nat_gateway = true
  single_nat_gateway = true
}

data "aws_subnet_ids" "default" {
  vpc_id = module.vpc.vpc_id
}
