resource "aws_wafv2_ip_set" "allowed" {
  name               = "${var.project_name}-allowed-ipset"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.allowed_ip_list
}

resource "aws_wafv2_web_acl" "this" {
  name  = var.waf_name
  scope = "REGIONAL"

  default_action {
    block {}
  }

  rule {
    name     = "Allow-Whitelisted-IPs"
    priority = 1

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.allowed.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AllowIPRule"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "WAF"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "alb_attach" {
  resource_arn = aws_lb.main.arn
  web_acl_arn  = aws_wafv2_web_acl.this.arn
}