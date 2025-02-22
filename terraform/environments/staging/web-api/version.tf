terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "consul" {
    path = "terraform/devops-task/web-api-staging"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}
