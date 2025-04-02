resource "aws_route53_record" "cdn_alias" {
  count   = var.zone_id == "" || var.domain_name == "" ? 0 : 1
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}
