output "region" {
  value = var.aws_region
}

output "vpc_cidr" {
  value = module.network.vpc_cidr
}

output "environment" {
  value = var.environment
}

output "alb_dns_name" {
  value = aws_lb.app.dns_name
}
output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "app_private_ip" {
  value = aws_instance.app.private_ip
}