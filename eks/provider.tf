terraform {
  backend "s3" {
    bucket = "greg-tr-terraform-state"
    key    = "greg-eks/terraform.tfstate"
    region = "eu-central-1"
  }

  required_version = ">= 0.13.0"
}

provider "aws" {
  region = var.aws_region
}
