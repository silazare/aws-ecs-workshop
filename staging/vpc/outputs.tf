output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "VPC ID"
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "Private subnets"
}

output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "Public subnets"
}

output "private_route_tables" {
  value       = module.vpc.private_route_table_ids
  description = "Private route tables"
}