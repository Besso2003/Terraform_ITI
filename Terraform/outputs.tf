output "region" {
  value = var.aws_region
}

output "vpc_cidr" {
  value = module.network.vpc_id
}

output "environment" {
  value = var.environment
}