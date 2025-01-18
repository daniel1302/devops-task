resource "aws_s3_bucket" "this" {
  bucket_prefix = "bucket${var.app_component_index}-${var.environment}-"

  tags = merge(local.common_tags, {
    name = "bucket${var.app_component_index}-${var.environment}"
  })
}


resource "aws_s3_bucket_public_access_block" "block_public_access_for_static_sites" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default_encryption" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "default_versioning" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Disabled"
  }
}

// Create default contents of the files but never update them if another version 
// of the file already exists. For example when deployed by an external CI/CD pipeline
resource "aws_s3_object" "default_index_content" {
  // Must have bucket versioning enabled first
  depends_on = [
    aws_s3_bucket_versioning.default_versioning,
    aws_s3_bucket_server_side_encryption_configuration.default_encryption,
    aws_s3_bucket_public_access_block.block_public_access_for_static_sites
  ]

  key          = "${var.app_component_path_prefix}/index.html"
  bucket       = aws_s3_bucket.this.id
  content      = "Hello from ${var.app_component}"
  content_type = "text/html"

  // Ignore changes to the file(this mean the terraform will not overwrite this file in future)
  # lifecycle {
  #   ignore_changes = all
  # }
}

resource "aws_s3_object" "default_404_content" {
  // Must have bucket versioning enabled first
  depends_on = [
    aws_s3_bucket_versioning.default_versioning,
    aws_s3_bucket_server_side_encryption_configuration.default_encryption,
    aws_s3_bucket_public_access_block.block_public_access_for_static_sites
  ]

  key          = "/404.html"
  bucket       = aws_s3_bucket.this.id
  content      = "Not found"
  content_type = "text/html"

  // Ignore changes to the file(this mean the terraform will not overwrite this file in future)
  # lifecycle {
  #   ignore_changes = all
  # }
}

