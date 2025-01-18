resource "aws_cloudfront_origin_access_control" "cloudfront_oac" {
  name                              = "cloudfront-distribution${var.app_component_index}-${var.environment}-oac"
  description                       = "S3 OAC for the cloudfront-distribution${var.app_component_index}-${var.environment}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "distribution" {
  enabled             = true
  default_root_object = "index.html"

  aliases = var.alternate_domain_names

  custom_error_response {
    error_code         = 404
    response_code      = 404
    response_page_path = "/404.html"
  }
  custom_error_response {
    error_code         = 403
    response_code      = 404
    response_page_path = "/404.html"
  }

  origin {
    domain_name              = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.this.id
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_oac.id
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = aws_s3_bucket.this.id

    forwarded_values { // I know it is deprecated, but still working fine :) And no custom cache is specified in the task.
      query_string = false

      cookies {
        forward = "all"
      }
    }

    dynamic "lambda_function_association" {
      for_each = coalesce([var.origin_request_lambda_edge_arn])

      content {
        event_type   = "origin-request"
        include_body = false
        lambda_arn   = lambda_function_association.value
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
    Name = "cloudfront-distribution${var.app_component_index}-${var.environment}"
  })
}