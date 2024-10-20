provider "aws" {
  region              = var.region
  allowed_account_ids = var.allowed_account_ids
}

module "vpc" {
  source = "../../../modules/network"

  name   = var.name
  cidr   = var.cidr
  region = var.region

}
