output "s3_bucket_id" {
  description = "ID of the buckets that store static files for the application"

  value = {
    bucket1 = aws_s3_bucket.bucket1.id
    bucket2 = aws_s3_bucket.bucket2.id
    bucket3 = aws_s3_bucket.bucket3.id
  }
}