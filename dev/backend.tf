terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
   backend "s3" {
    bucket = "daws76s-divya-dev"
    key    = "roboshop-user-dev-deploy"
    region = "us-east-1"
    dynamodb_table = "locktable-dev"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
