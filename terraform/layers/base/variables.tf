variable "azs" {
  description = "List of availability zones."
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

variable "project" {
  description = "Project name"
  type = string
  default = "terraform lab"
}

variable "envrionment" {
    description = "Deployment Environment"
    type = string
    default = "dev"
}


variable "vpc_cidr" {
  description = "CIDR range for VPC"
  type = string
}