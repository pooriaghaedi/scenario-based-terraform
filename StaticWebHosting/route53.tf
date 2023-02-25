resource "aws_route53_record" "Examplewebsite" {
  zone_id = data.aws_route53_zone.exampleTLD.zone_id
  name    = "${local.subdomain}.${local.TLD}"
  type    = "CNAME"
  ttl     = "300"
  records = [aws_cloudfront_distribution.cf_distribution.domain_name]
}