terraform {
  required_version = "~> 1.14.4"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Environment = var.envrionment
      Project = var.project
      CreatedBy = "jibran"
    }
  }
  
}
