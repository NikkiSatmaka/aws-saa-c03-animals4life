data "aws_availability_zones" "available" {}

locals {
  # AZ Calculation
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  az_count = length(local.azs)

  # Number of subnet types for each AZ
  subnet_type_count = 4 # [reserved, db, app, web]

  cidr_count  = local.az_count * local.subnet_type_count
  subnet_bits = ceil(log(local.cidr_count, 2))

  all_subnet_index = range(local.cidr_count)
  all_subnet_cidrs = [for netnumber in local.all_subnet_index : cidrsubnet(var.cidr, local.subnet_bits, netnumber)]

  reserved_subnet_index = [for i in local.all_subnet_index : i if i % local.subnet_type_count == 0] # [0, 4, 8]
  db_subnet_index       = [for i in local.all_subnet_index : i if i % local.subnet_type_count == 1] # [1, 5, 9]
  app_subnet_index      = [for i in local.all_subnet_index : i if i % local.subnet_type_count == 2] # [2, 6, 10]
  web_subnet_index      = [for i in local.all_subnet_index : i if i % local.subnet_type_count == 3] # [3, 7, 11]

  reserved_subnet_cidrs = [for i in local.reserved_subnet_index : local.all_subnet_cidrs[i]]
  db_subnet_cidrs       = [for i in local.db_subnet_index : local.all_subnet_cidrs[i]]
  app_subnet_cidrs      = [for i in local.app_subnet_index : local.all_subnet_cidrs[i]]
  web_subnet_cidrs      = [for i in local.web_subnet_index : local.all_subnet_cidrs[i]]

  reserved_subnet_names = [for az in local.azs : "${var.name}-reserved-${substr(az, -1, 1)}"]
  db_subnet_names       = [for az in local.azs : "${var.name}-db-${substr(az, -1, 1)}"]
  app_subnet_names      = [for az in local.azs : "${var.name}-app-${substr(az, -1, 1)}"]
  web_subnet_names      = [for az in local.azs : "${var.name}-web-${substr(az, -1, 1)}"]

}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = var.cidr

  azs = local.azs

  private_subnets      = concat(local.reserved_subnet_cidrs, local.db_subnet_cidrs, local.app_subnet_cidrs)
  public_subnets       = local.web_subnet_cidrs
  private_subnet_names = concat(local.reserved_subnet_names, local.db_subnet_names, local.app_subnet_names)
  public_subnet_names  = local.web_subnet_names

  enable_ipv6                  = true
  private_subnet_ipv6_prefixes = concat(local.reserved_subnet_index, local.db_subnet_index, local.app_subnet_index)
  public_subnet_ipv6_prefixes  = local.web_subnet_index

  private_subnet_assign_ipv6_address_on_creation = true
  public_subnet_assign_ipv6_address_on_creation  = true

  enable_dns_support   = true
  enable_dns_hostnames = true

  map_public_ip_on_launch                = true
  create_igw                             = true
  create_egress_only_igw                 = false
  create_database_internet_gateway_route = false
  create_database_nat_gateway_route      = false

  enable_nat_gateway     = false
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

}
