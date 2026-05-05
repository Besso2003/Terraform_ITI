terraform {
  backend "s3" {
    bucket         = "bassant-tf-state"
    key            = "terraform/state.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "terraform-lock-table"
    profile        = "bassant"
  }
}