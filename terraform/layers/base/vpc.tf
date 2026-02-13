data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  az_count = length(data.aws_availability_zones.available.names)
}

module "vpc" {
    source = "terraform-aws-modules/vpc/aws"
    name = "${var.project}-${var.envrionment}-vpc"
    cidr = var.vpc_cidr

    azs = data.aws_availability_zones.available.names
    private_subnets = [for i in range(local.az_count) : cidrsubnet(var.vpc_cidr, 3, i + local.az_count)]
    public_subnets  = [for i in range(local.az_count) : cidrsubnet(var.vpc_cidr, 3, i)]

    enable_nat_gateway = true
    

    single_nat_gateway = var.envrionment == "dev" ? true : false

    one_nat_gateway_per_az = var.envrionment == "dev" ? false : true


}