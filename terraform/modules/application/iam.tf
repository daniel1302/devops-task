data "aws_iam_policy_document" "s3_bucket_policy" {
  for_each = {
    auth = {
      bucket_arn = aws_s3_bucket.bucket1.arn
      cloudfront_arn = aws_cloudfront_distribution.distribution["auth"].arn
    },
    info = {
      bucket_arn = aws_s3_bucket.bucket2.arn
      cloudfront_arn = aws_cloudfront_distribution.distribution["info"].arn
    },
    customers = {
      bucket_arn = aws_s3_bucket.bucket3.arn
      cloudfront_arn = aws_cloudfront_distribution.distribution["customers"].arn
    }
  }
    
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${each.value.bucket_arn}/*"]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [each.value.cloudfront_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "static_site_bucket_policy" {
  for_each = {
    auth      = aws_s3_bucket.bucket1.id
    info      = aws_s3_bucket.bucket2.id
    customers = aws_s3_bucket.bucket3.id
  }
  
  bucket = each.value
  policy = data.aws_iam_policy_document.s3_bucket_policy[each.key].json
}
