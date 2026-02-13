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