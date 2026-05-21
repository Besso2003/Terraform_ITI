# Jenkins own VPC (completely independent of infra)
resource "aws_vpc" "jenkins" {
  cidr_block = var.jenkins_vpc_cidr
  tags       = { Name = "jenkins-vpc" }
}

resource "aws_internet_gateway" "jenkins" {
  vpc_id = aws_vpc.jenkins.id
  tags   = { Name = "jenkins-igw" }
}

resource "aws_subnet" "jenkins" {
  vpc_id                  = aws_vpc.jenkins.id
  cidr_block              = var.jenkins_subnet_cidr
  availability_zone       = var.jenkins_availability_zone
  map_public_ip_on_launch = true
  tags                    = { Name = "jenkins-public-subnet" }
}

resource "aws_route_table" "jenkins" {
  vpc_id = aws_vpc.jenkins.id
  tags   = { Name = "jenkins-rt" }
}

resource "aws_route" "jenkins_internet" {
  route_table_id         = aws_route_table.jenkins.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.jenkins.id
}

resource "aws_route_table_association" "jenkins" {
  subnet_id      = aws_subnet.jenkins.id
  route_table_id = aws_route_table.jenkins.id
}

# Security group
resource "aws_security_group" "jenkins" {
  name   = "jenkins-sg"
  vpc_id = aws_vpc.jenkins.id
  tags   = { Name = "jenkins-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_ui" {
  security_group_id = aws_security_group.jenkins.id
  cidr_ipv4         = var.allowed_cidr
  from_port         = 8080
  to_port           = 8080
  ip_protocol       = "tcp"
  description       = "Jenkins web UI"
}

resource "aws_vpc_security_group_ingress_rule" "jenkins_ssh" {
  security_group_id = aws_security_group.jenkins.id
  cidr_ipv4         = var.allowed_cidr
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "SSH to Jenkins"
}

resource "aws_vpc_security_group_egress_rule" "jenkins_all" {
  security_group_id = aws_security_group.jenkins.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Key pair
resource "aws_key_pair" "jenkins" {
  key_name   = "jenkins-key"
  public_key = file(var.public_key_path)
}

# IAM role + instance profile
resource "aws_iam_role" "jenkins" {
  name = "jenkins-ec2-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "jenkins_infra" {
  name = "jenkins-infra-policy"
  role = aws_iam_role.jenkins.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ec2:*", "rds:*", "elasticache:*",
        "elasticloadbalancing:*", "lambda:*",
        "s3:*", "dynamodb:*",
        "iam:PassRole", "iam:GetRole",
        "logs:*", "archive:*"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_instance_profile" "jenkins" {
  name = "jenkins-instance-profile"
  role = aws_iam_role.jenkins.name
}

# Jenkins EC2
resource "aws_instance" "jenkins" {
  ami                         = var.jenkins_ami
  instance_type               = var.jenkins_instance_type
  subnet_id                   = aws_subnet.jenkins.id
  vpc_security_group_ids      = [aws_security_group.jenkins.id]
  key_name                    = aws_key_pair.jenkins.key_name
  iam_instance_profile        = aws_iam_instance_profile.jenkins.name
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf update -y
    dnf install -y docker
    systemctl enable docker
    systemctl start docker
    usermod -aG docker ec2-user

    docker run -d \
      --name jenkins \
      --restart=unless-stopped \
      -p 8080:8080 \
      -p 50000:50000 \
      -v jenkins_home:/var/jenkins_home \
      jenkins/jenkins:lts-jdk17
  EOF

  tags = { 
    Name = "jenkins-server" 
   }
}