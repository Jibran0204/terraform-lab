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
