resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {
  security_group_id = aws_security_group.bastion_sg.id
  description       = "Allow SSH access from anywhere bastion security group"

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "app_ssh" {
  security_group_id            = aws_security_group.app_sg.id
  description                  = "Allow SSH access from bastion security group"
  referenced_security_group_id = aws_security_group.bastion_sg.id

  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_vpc_security_group_ingress_rule" "app_3000" {
  security_group_id            = aws_security_group.app_sg.id
  description                  = "Allow ALB access to application port 3000"
  referenced_security_group_id = aws_security_group.alb_sg.id

  from_port   = 3000
  to_port     = 3000
  ip_protocol = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_ui" {
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "0.0.0.0/0"   # lock down to your IP in prod
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"
  description       = "Jenkins web UI"
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_ssh" {
  security_group_id = aws_security_group.jenkins_sg.id
  cidr_ipv4         = "0.0.0.0/0"   # lock to your IP
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "SSH to Jenkins"
}

resource "aws_vpc_security_group_ingress_rule" "app_ssh_from_jenkins" {
  security_group_id            = aws_security_group.app_sg.id
  referenced_security_group_id = aws_security_group.jenkins_sg.id
  from_port                    = 22
  to_port                      = 22
  ip_protocol                  = "tcp"
  description                  = "Allow Jenkins to SSH into app node"
}