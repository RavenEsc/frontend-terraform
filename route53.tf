# data "aws_route53_zone" "primary" {
#     name = var.domainname
# }

# resource "aws_route53_record" "www" {
#   zone_id = data.aws_route53_zone.primary.zone_id
#   name    = var.domainname
#   type    = "A"

#   alias {
#     name                    = aws_s3_bucket_website_configuration.config.website_domain
#     zone_id                 = aws_s3_bucket.buck.hosted_zone_id
#     evaluate_target_health  = true
#   }
# }

# resource "aws_acm_certificate" "cert" {
#   domain_name       = "www.${domainname}"
#   validation_method = "DNS"

#   tags = {
#     Environment = "test"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

