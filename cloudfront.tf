resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket_website_configuration.config.website_endpoint
    origin_id   = aws_s3_bucket.buck.id
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "IaC: Terraform resume challenge build"
  default_root_object = "index.html"
  http_version = "http2"

  # aliases = ["ravens-resume-crc.com", "*.ravens-resume-crc.com"]

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.buck.id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US"]
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    # acm_certificate_arn = aws_acm_certificate_validation.cf_cert_validation.certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

### THE FUN, check here for errors!

# aws ssl certificate for cloudfront

provider "aws" {
  alias = "acm-provider"
  profile = var.profilename
  region = "us-east-1"
}

resource "aws_acm_certificate" "cf-ssl-certificate" {
  provider = aws.acm-provider
  # domain_name = "ravens-resume-crc.com"
  validation_method = "DNS"
  timeouts {
    create = "40m"
  }
}

resource "aws_acm_certificate_validation" "cf_cert_validation" {
  provider = aws.acm-provider
  certificate_arn = aws_acm_certificate.cf-ssl-certificate.arn
}