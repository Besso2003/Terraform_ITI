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

variable "vpc_cidr" {
  type = string
}