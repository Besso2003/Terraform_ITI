variable "aws_region" {
  type = string
}

variable "backend_region" {
  type    = string
  default = "eu-north-1"
}

variable "vpc_cidr" {
  type = string
}

variable "environment" {
  type = string
}

variable "bastion_instance_type" {
  type = string
}

variable "app_instance_type" {
  type = string
}

variable "bastion_name" {
  type = string
}

variable "app_name" {
  type = string
}

variable "bastion_ami" {
  type = string
}

variable "app_ami" {
  type = string
}

variable "public_subnets" {
  type = list(object({
    name               = string
    cidr               = string
    availability_zone = string
  }))
}

variable "private_subnets" {
  type = list(object({
    name               = string
    cidr               = string
    availability_zone = string
  }))
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "key_pair_name" {
  type    = string
  default = null
}

variable "db_name" {
  type = string
}

