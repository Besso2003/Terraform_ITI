resource "aws_key_pair" "main" {
  key_name   = "bastion-key-${var.environment}"
  public_key = file(var.public_key_path)
}