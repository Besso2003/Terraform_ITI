resource "aws_instance" "bastion" {
  ami                    = var.bastion_ami
  instance_type          = var.bastion_instance_type
  subnet_id              = module.network.public_subnet_ids["public-subnet-1"]
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  tags = {
    Name = var.bastion_name
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip}"
  }
}

resource "aws_instance" "app" {
  ami                    = var.app_ami
  instance_type          = var.app_instance_type
  subnet_id              = module.network.private_subnet_ids["private-subnet-1"]
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = var.app_name
  }

  provisioner "local-exec" {
    command = "echo ${self.private_ip}"
  }
}