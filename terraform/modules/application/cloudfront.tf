locals {
    cloudfront_distribution_names = {
    auth = "cloudfront-distribution1"
    info = "cloudfront-distribution2"
    customers = "cloudfront-distribution3"
  }
  cloudfront_distribution_s3_bucket_id_map = {
    auth = aws_s3_bucket.bucket1.id
    info = aws_s3_bucket.bucket2.id
    customers = aws_s3_bucket.bucket3.id
  }
  cloudfront_distribution_s3_bucket_regional_domain_name_map = {
    auth = aws_s3_bucket.bucket1.bucket_regional_domain_name
    info = aws_s3_bucket.bucket2.bucket_regional_domain_name
    customers = aws_s3_bucket.bucket3.bucket_regional_domain_name
  }
}

resource "aws_cloudfront_origin_access_control" "cloudfront_oac" {
  for_each = local.cloudfront_distribution_names

  name                              = "${each.value}-oac"
  description                       = "S3 OAC for the ${each.value}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "distribution" {
  for_each = {
    auth = "cloudfront-distribution1"
    info = "cloudfront-distribution2"
    customers = "cloudfront-distribution3"
  }

  enabled             = true
  default_root_object = "index.html"

  custom_error_response {
    error_code = 404
    response_code = 404
    response_page_path = "/404.html"
  }
  custom_error_response {
    error_code = 403
    response_code = 404
    response_page_path = "/404.html"
  }

  origin {
    domain_name              = local.cloudfront_distribution_s3_bucket_regional_domain_name_map[each.key]
    origin_id                = local.cloudfront_distribution_s3_bucket_id_map[each.key]
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_oac[each.key].id
  }

  ordered_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.cloudfront_distribution_s3_bucket_id_map[each.key]
    path_pattern =  "${each.key}/"

    forwarded_values { // I know it is deprecated, but still working fine :) 
      query_string = false

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.cloudfront_distribution_s3_bucket_id_map[each.key]

    forwarded_values { // I know it is deprecated, but still working fine :) 
      query_string = false

      cookies {
        forward = "all"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = merge(local.common_tags, {
    Name = each.value
  })
}