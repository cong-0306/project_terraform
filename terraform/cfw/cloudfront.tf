resource "aws_cloudfront_distribution" "main" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "Global CloudFront for ${var.domain_name}"

  aliases = [var.domain_name]

  # -------------------------
  # Origin (Primary: Seoul)
  # -------------------------
  origin {
    domain_name = var.seoul_origin_dns
    origin_id   = "seoul-origin"

    custom_origin_config {
      origin_protocol_policy = "https-only"
      https_port             = 443
      http_port              = 80
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # -------------------------
  # Origin (Secondary: DR)
  # -------------------------
  origin {
    domain_name = var.dr_origin_dns
    origin_id   = "dr-origin"

    custom_origin_config {
      origin_protocol_policy = "https-only"
      https_port             = 443
      http_port              = 80
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # -------------------------
  # Origin Group (Failover)
  # -------------------------
  origin_group {
    origin_id = "origin-group-main"

    failover_criteria {
      status_codes = [403, 404, 500, 502, 503, 504]
    }

    member { origin_id = "seoul-origin" }
    member { origin_id = "dr-origin" }
  }

  # -------------------------
  # API 전용 Behavior (POST 허용)
  # -------------------------
  ordered_cache_behavior {
    path_pattern           = "/api/*"
    target_origin_id       = "seoul-origin"   # ← origin-group 아님
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = [
      "GET",
      "HEAD",
      "OPTIONS",
      "PUT",
      "POST",
      "PATCH",
      "DELETE"
    ]

    cached_methods = ["GET", "HEAD"]

    forwarded_values {
      query_string = true

      headers = [
        "Host",
        "Authorization"
      ]

      cookies {
        forward = "all"
      }
    }

    min_ttl     = 0
    default_ttl = 0
    max_ttl     = 0
  }

  # -------------------------
  # Default (Failover GET 전용)
  # -------------------------
  default_cache_behavior {
    target_origin_id       = "origin-group-main"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = true
      headers      = ["Host"]

      cookies {
        forward = "all"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = var.acm_cert_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  web_acl_id = aws_wafv2_web_acl.main.arn
}