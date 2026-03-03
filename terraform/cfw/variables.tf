variable "domain_name" {
  type        = string
  description = "Primary domain (ex: justic.store)"
}

variable "acm_cert_arn" {
  type        = string
  description = "ACM certificate ARN from us-east-1"
}

variable "waf_name" {
  type        = string
  description = "WAF name"
}

variable "seoul_origin_dns" {
  type        = string
  description = "Seoul NLB or ALB DNS"
}

variable "dr_origin_dns" {
  type        = string
  description = "DR ALB DNS"
}