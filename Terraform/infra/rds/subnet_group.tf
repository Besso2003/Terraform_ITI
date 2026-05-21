resource "aws_db_subnet_group" "app_db_subnet_group" {
  name       = "app-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "app-db-subnet-group"
  }
}