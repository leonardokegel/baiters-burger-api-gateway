terraform {
  backend "s3" {
    bucket = "my-baiters-state-bucket-eks"
    key    = "terraform/state.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}