terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
   backend "s3" {
    bucket = "daws76s-divya-prod"
    key    = "roboshop-user-prod-deploy"
    region = "us-east-1"
    dynamodb_table = "locktable-prod"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
