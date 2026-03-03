variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_ids" {
  type = list(string)
}

variable "waf_name" {
  type = string
}

variable "allowed_ip_list" {
  type = list(string)
}

variable "rosa_nlb_dns_name" {
  description = "ROSA router-default NLB DNS name"
  type        = string
}