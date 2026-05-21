resource "aws_security_group" "bastion_sg" {
  name   = "bastion-sg"
  vpc_id = module.network.vpc_id

  tags = {
    Name = "bastion-sg"
  }
}

resource "aws_security_group" "app_sg" {
  name   = "app-sg"
  vpc_id = module.network.vpc_id

  tags = {
    Name = "app-sg"
  }
}

resource "aws_security_group" "jenkins_sg" {
  name   = "jenkins-sg"
  vpc_id = module.network.vpc_id
  
  tags   = { 
    Name = "jenkins-sg" 
  }
}