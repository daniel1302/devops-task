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

resource "aws_s3_bucket_public_access_block" "block_public_access_for_static_sites" {
  for_each = {
    auth      = aws_s3_bucket.bucket1.id,
    info      = aws_s3_bucket.bucket2.id,
    customers = aws_s3_bucket.bucket3.id,
  }

  bucket = each.value

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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
resource "aws_s3_object" "default_index_content" {
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
      bucket_id = aws_s3_bucket.bucket3.id
      content   = "Hello from Customers"
    }
  }

  // Must have bucket versioning enabled first
  depends_on = [
    aws_s3_bucket_versioning.default_versioning,
    aws_s3_bucket_server_side_encryption_configuration.default_encryption,
    aws_s3_bucket_public_access_block.block_public_access_for_static_sites
  ]

  key     = "${each.key}/index.html"
  bucket  = each.value.bucket_id
  content = each.value.content
  content_type = "text/html"

  // Ignore changes to the file(this mean the terraform will not overwrite this file in future)
  # lifecycle {
  #   ignore_changes = all
  # }
}


resource "aws_s3_object" "default_error_content" {
  for_each = {
    auth      = aws_s3_bucket.bucket1.id
    info      = aws_s3_bucket.bucket2.id
    customers = aws_s3_bucket.bucket3.id
  }

  // Must have bucket versioning enabled first
  depends_on = [
    aws_s3_bucket_versioning.default_versioning,
    aws_s3_bucket_server_side_encryption_configuration.default_encryption,
    aws_s3_bucket_public_access_block.block_public_access_for_static_sites
  ]

  key     = "404.html"
  bucket  = each.value
  content = "Not found"
  content_type = "text/html"

  // Ignore changes to the file(this mean the terraform will not overwrite this file in future)
  # lifecycle {
  #   ignore_changes = all
  # }
}

