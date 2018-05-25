provider "aws" {
  region = "us-west-1"
}

module "vpc" {
  source = "./modules/vpc"

  name = "${var.name}"

  cidr = "${var.cidr}"

  azs             = "${var.azs}"
  private_subnets = "${var.private_subnets}"
  public_subnets  = "${var.public_subnets}"

  enable_nat_gateway = "${var.enable_nat_gateway}"
  single_nat_gateway = "${var.single_nat_gateway}"

  tags = {
    Owner       = "Ihar"
    Environment = "dev"
  }
}
