output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "reserved_subnet_cidrs" {
  description = "The IP CIDRs for reserved subnet"
  value       = local.reserved_subnet_cidrs
}

output "db_subnet_cidrs" {
  description = "The IP CIDRs for db subnet"
  value       = local.db_subnet_cidrs
}

output "app_subnet_cidrs" {
  description = "The IP CIDRs for app subnet"
  value       = local.app_subnet_cidrs
}

output "web_subnet_cidrs" {
  description = "The IP CIDRs for web subnet"
  value       = local.web_subnet_cidrs
}
