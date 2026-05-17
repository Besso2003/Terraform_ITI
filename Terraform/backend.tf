terraform {
  backend "s3" {
    bucket         = "bassant-tf-state-v2"
    key            = "terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-lock-table"
    # profile        = "bassant"
  }
}