resource "aws_cloudfront_origin_access_identity" "websiteOAI" {
  comment    = "${local.name} website Origin Access Identity"
}

resource "aws_cloudfront_cache_policy" "cf_cache_policy" {
  name        = "${local.name}-cache-policy"
  comment     = "${local.TLD} ${local.name} Cache Policy"

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_gzip = true
    cookies_config {
      cookie_behavior = "all"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "all"
    }
  }
}

resource "aws_cloudfront_distribution" "cf_distribution" {
  enabled             = true
  is_ipv6_enabled     = false
  comment             = "example Website"
  aliases             = "${local.subdomain}.${local.TLD}"
  default_root_object = "index.html"
  price_class = "PriceClass_All"
  origin {
    domain_name =  aws_s3_bucket.website.bucket_regional_domain_name
    origin_id   = "WebsiteOnS3"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.websiteOAI.cloudfront_access_identity_path
    }
  }


  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET","HEAD"]
    target_origin_id = "WebsiteOnS3"
    compress 	       = true
    viewer_protocol_policy = "redirect-to-https"
  forwarded_values {
      query_string = true

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
    cloudfront_default_certificate = false
    acm_certificate_arn = aws_acm_certificate.example.arn
    ssl_support_method  = "sni-only"
  }

   custom_error_response  {
   error_code = 404
   response_code = 200
   response_page_path =  "/index.html"
   error_caching_min_ttl = 5
  }
  custom_error_response  {
   error_code = 403
   response_code = 200
   response_page_path =  "/index.html"
   error_caching_min_ttl = 5
  }
   custom_error_response {
   error_code = 400
   response_code = 200
   response_page_path =  "/index.html"
   error_caching_min_ttl = 5
  }
}