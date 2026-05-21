terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider for environment-specific resources
provider "aws" {
  region = var.aws_region
  # profile = "bassant"
}

# Configure a separate AWS Provider for the shared S3 backend bucket region
provider "aws" {
  alias  = "backend"
  region = var.backend_region
}