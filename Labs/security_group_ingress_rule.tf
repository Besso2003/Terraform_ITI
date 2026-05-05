resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {
  security_group_id = aws_security_group.bastion_sg.id
  description       = "Allow SSH access from anywhere bastion security group"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "app_ssh" {
  security_group_id = aws_security_group.app_sg.id
  description       = "Allow SSH access from application security group"

  cidr_ipv4   = module.network.vpc_cidr
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "app_3000" {
  security_group_id = aws_security_group.app_sg.id
  description       = "Allow access to port 3000 from application security group"

  cidr_ipv4   = module.network.vpc_cidr
  from_port   = 3000
  to_port     = 3000
  ip_protocol = "tcp"
}