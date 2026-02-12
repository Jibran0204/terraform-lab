locals {
  az_count = length(var.azs)
  public_subnets  = [for i in range(local.az_count) : cidrsubnet(var.vpc_cidr, 3, i)]
  private_subnets = [for i in range(local.az_count) : cidrsubnet(var.vpc_cidr, 3, i + local.az_count)]
}
module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    name = "my-vpc"
    cidr = var.vpc_cidr

    azs = var.azs
    private_subnets = local.private_subnets
    public_subnets  = local.public_subnets

    enable_nat_gateway = true
    enable_vpn_gateway = true

    tags = {
        Terraform = "true"
        Environment = var.envrionment
    }
}