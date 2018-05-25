variable "name" {}
variable "create_vpc" {}
variable "cidr" {}
variable "instance_tenancy" {}
variable "public_subnets" {}
variable "private_subnets" {}
variable "database_subnets" {}
variable "redshift_subnets" {}
variable "elasticache_subnets" {}
variable "create_database_subnet_group" {}
variable "azs" {}
variable "enable_dns_hostnames" {}
variable "enable_dns_support" {}
variable "enable_nat_gateway" {}
variable "single_nat_gateway" {}
variable "one_nat_gateway_per_az" {}
variable "reuse_nat_ips" {}
variable "external_nat_ip_ids" {}
variable "enable_dynamodb_endpoint" {}
variable "enable_s3_endpoint" {}
variable "map_public_ip_on_launch" {}
variable "enable_vpn_gateway" {}
variable "vpn_gateway_id" {}
variable "propagate_private_route_tables_vgw" {}
variable "propagate_public_route_tables_vgw" {}
variable "tags" {}
variable "vpc_tags" {}
variable "public_subnet_tags" {}
variable "private_subnet_tags" {}
variable "default_route_table_tags" {}
variable "public_route_table_tags" {}
variable "private_route_table_tags" {}
variable "database_subnet_tags" {}
variable "redshift_subnet_tags" {}
variable "elasticache_subnet_tags" {}
variable "dhcp_options_tags" {}
variable "enable_dhcp_options" {}
variable "dhcp_options_domain_name" {}
variable "dhcp_options_domain_name_servers" {}
variable "dhcp_options_ntp_servers" {}
variable "dhcp_options_netbios_name_servers" {}
variable "dhcp_options_netbios_node_type" {}
variable "manage_default_vpc" {}
variable "default_vpc_name" {}
variable "default_vpc_enable_dns_support" {}
variable "default_vpc_enable_dns_hostnames" {}
variable "default_vpc_enable_classiclink" {}
variable "default_vpc_tags" {}

  
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
