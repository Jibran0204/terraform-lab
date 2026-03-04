
data "aws_vpc" "grad_lab_vpc" {
  filter {
    name   = "tag:Name"
    values = ["${var.project}-${var.environment}-vpc"] # 
  }
}


data "aws_subnets" "grad_lab_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.grad_lab_vpc.id] 
  }
  filter {
    name   = "tag:Name"
    values = ["${var.project}-${var.environment}-vpc-public-*"]
  }
}


resource "aws_security_group" "grad-lab-alb-sg" {
  name        = "${var.project}-${var.environment}-alb-sg" 
  description = "ALB security group"
  vpc_id      = data.aws_vpc.grad_lab_vpc.id 
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.grad-lab-alb-sg.id 
  from_port         = 80 
  to_port           = 80 
  ip_protocol       = "tcp" 
  cidr_ipv4         = "0.0.0.0/0" 
}

resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.grad-lab-alb-sg.id 
  from_port         = 443 
  to_port           = 443 
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.grad-lab-alb-sg.id 
  ip_protocol       = "-1" 
  cidr_ipv4         = "0.0.0.0/0"
}


module "grad-lab-alb" {
    source = "terraform-aws-modules/alb/aws" 

    name = "${var.project}-${var.environment}-alb" 

    load_balancer_type = "application"
    create_security_group = false 
    enable_deletion_protection = false

    vpc_id          = data.aws_vpc.grad_lab_vpc.id 
    subnets         = data.aws_subnets.grad_lab_public_subnets.ids
    security_groups = [aws_security_group.grad-lab-alb-sg.id] 
    
    target_groups = {
      web = {
        name_prefix      = "web-" 
        backend_protocol = "HTTP"
        backend_port     = 80 
        target_type      = "instance" 
        create_attachment = false
        health_check = {
          path                = "/"
          port                = 80 
          matcher             = "200"
          interval            = 120
          unhealthy_threshold = 5 
        }
      }
    }
}