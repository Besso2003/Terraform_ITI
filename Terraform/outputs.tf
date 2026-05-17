output "region" {
  value = var.aws_region
}

output "vpc_cidr" {
  value = module.network.vpc_cidr
}

output "environment" {
  value = var.environment
}