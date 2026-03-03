output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "waf_arn" {
  value = aws_wafv2_web_acl.this.arn
}