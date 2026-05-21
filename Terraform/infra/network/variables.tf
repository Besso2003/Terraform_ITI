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

variable "vpc_cidr" {
  type = string
}