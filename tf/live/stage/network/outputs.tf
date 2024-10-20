output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "reserved_subnet_cidrs" {
  description = "The IP CIDRs for reserved subnet"
  value       = module.vpc.reserved_subnet_cidrs
}

output "db_subnet_cidrs" {
  description = "The IP CIDRs for db subnet"
  value       = module.vpc.db_subnet_cidrs
}

output "app_subnet_cidrs" {
  description = "The IP CIDRs for app subnet"
  value       = module.vpc.app_subnet_cidrs
}

output "web_subnet_cidrs" {
  description = "The IP CIDRs for web subnet"
  value       = module.vpc.web_subnet_cidrs
}
