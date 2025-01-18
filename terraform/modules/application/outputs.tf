output "bucket_id" {
  value = aws_s3_bucket.this.id
}

output "cloudfront_arn" {
  value = aws_cloudfront_distribution.distribution.arn
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.distribution.domain_name
}