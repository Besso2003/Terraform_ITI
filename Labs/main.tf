module "network" {
  source = "./network"
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  vpc_cidr       = var.vpc_cidr
}