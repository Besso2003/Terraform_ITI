resource "aws_elasticache_subnet_group" "redis_subnet" {
  name       = "redis-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "redis-subnet-group"
  }
}