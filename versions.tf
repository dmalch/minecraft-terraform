terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.55.0"
    }
  }

  backend "s3" {
    bucket = "dmalch-terraform-state"
    key    = "prod/terraform.tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  profile = "default"
  region  = local.region
}
