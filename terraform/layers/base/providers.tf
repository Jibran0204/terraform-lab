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
      Project = var.project
      Envrionment = var.envrionment
      CreatedBy = "Terraform"
    }
    
  }
  
}