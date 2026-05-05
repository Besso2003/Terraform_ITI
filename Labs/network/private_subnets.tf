resource "aws_subnet" "private" {
  for_each = { for subnet in var.private_subnets : subnet.name => subnet }

  vpc_id     = aws_vpc.main.id
  cidr_block = each.value.cidr

  tags = {
    Name = each.value.name
  }
}