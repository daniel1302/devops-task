locals {
  common_tags = {
    app   = var.app_name
    env   = var.environment
    owner = var.app_owner
  }
}

resource "aws_s3_bucket" "bucket1" {
  bucket_prefix = "bucket1-${var.environment}-"

  tags = merge(local.common_tags, {
    name = "bucket1-${var.environment}"
  })
}

resource "aws_s3_bucket" "bucket2" {
  bucket_prefix = "bucket2-${var.environment}-"

  tags = merge(local.common_tags, {
    name = "bucket2-${var.environment}"
  })
}

resource "aws_s3_bucket" "bucket3" {
  bucket_prefix = "bucket3-${var.environment}-"

  tags = merge(local.common_tags, {
    name = "bucket3-${var.environment}"
  })
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default_encryption" {
  for_each = {
    auth      = aws_s3_bucket.bucket1.id,
    info      = aws_s3_bucket.bucket2.id,
    customers = aws_s3_bucket.bucket3.id,
  }

  bucket = each.value

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "default_versioning" {
  for_each = {
    auth      = aws_s3_bucket.bucket1.id,
    info      = aws_s3_bucket.bucket2.id,
    customers = aws_s3_bucket.bucket3.id,
  }

  bucket = each.value

  versioning_configuration {
    status     = "Enabled"
    mfa_delete = "Disabled"
  }
}

// Create default contents of the files but never update them if another version 
// of the file already exists. For example when deployed by an external CI/CD pipeline
resource "aws_s3_object" "default_api_content" {
  for_each = {
    auth = {
      bucket_id = aws_s3_bucket.bucket1.id
      content   = "Hello from Auth"
    },
    info = {
      bucket_id = aws_s3_bucket.bucket2.id
      content   = "Hello from Info"
    },
    customers = {
      bucket_id = aws_s3_bucket.bucket1.id
      content   = "Hello from Customers"
    }
  }

  // Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.default_versioning]

  key     = "index.html"
  bucket  = each.value.bucket_id
  content = each.value.content

  // Ignore changes to the
  lifecycle {
    ignore_changes = all
  }
}
