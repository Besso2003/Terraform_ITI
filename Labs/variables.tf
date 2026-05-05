variable "aws_region" {
  type = string
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
    name = string
    cidr = string
  }))
}

variable "private_subnets" {
  type = list(object({
    name = string
    cidr = string
  }))
}