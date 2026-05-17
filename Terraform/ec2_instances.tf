resource "aws_instance" "bastion" {
  ami                    = var.bastion_ami
  instance_type          = var.bastion_instance_type
  subnet_id              = module.network.public_subnet_ids["public-subnet-1"]
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = var.key_pair_name

  tags = {
    Name = var.bastion_name
  }
}

resource "aws_instance" "app" {
  ami                    = var.app_ami
  instance_type          = var.app_instance_type
  subnet_id              = module.network.private_subnet_ids["private-subnet-1"]
  vpc_security_group_ids = [aws_security_group.app_sg.id]
  key_name               = var.key_pair_name

  tags = {
    Name = var.app_name
  }
}