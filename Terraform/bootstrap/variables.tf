variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "allowed_cidr" {
  type        = string
  description = "Your IP in CIDR, e.g. 1.2.3.4/32"
}

variable "public_key_path" {
  type        = string
  description = "Path to your local SSH public key"
}

variable "jenkins_ami" {
  type        = string
  description = "Amazon Linux 2 AMI for eu-north-1"
}

variable "jenkins_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "jenkins_vpc_cidr" {
  type    = string
  default = "192.168.0.0/16"
}

variable "jenkins_subnet_cidr" {
  type    = string
  default = "192.168.1.0/24"
}

variable "jenkins_availability_zone" {
  type    = string
  default = "eu-north-1a"
}