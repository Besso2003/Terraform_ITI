module "network" {
  source          = "./network"
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  vpc_cidr        = var.vpc_cidr
}

module "rds" {
  source = "./rds"
  db_name  = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  subnet_ids = values(module.network.private_subnet_ids)
  app_security_group_id = aws_security_group.app_sg.id
  vpc_id = module.network.vpc_id
}

module "redis" {
  source = "./elasticache"

  vpc_id     = module.network.vpc_id
  subnet_ids = values(module.network.private_subnet_ids)
  app_security_group_id = aws_security_group.app_sg.id
}