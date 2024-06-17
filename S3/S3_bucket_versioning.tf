resource "aws_s3_bucket" "versioning_bucket" {
  count = var.enabled ? 0 : 1

  bucket = var.my-versioning-bucket
}

resource "aws_s3_bucket_acl" "versioning_bucket_acl" {
  count = var.enabled ? 0 : 1

  bucket = aws_s3_bucket.versioning_bucket[count.index].id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.versioning_bucket]
}

resource "aws_s3_bucket_ownership_controls" "versioning_bucket" {
  count = var.enabled ? 0 : 1 
  bucket = aws_s3_bucket.versioning_bucket[count.index].id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  count = var.enabled ? 0 : 1

  bucket = aws_s3_bucket.versioning_bucket[count.index].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "versioning-bucket-config" {
  # Must have bucket versioning enabled first
  count = var.enabled ? 0 : 1
  depends_on = [aws_s3_bucket_versioning.versioning]

  bucket = aws_s3_bucket.versioning_bucket[count.index].id

  rule {
    id = "all_documents"

    filter { }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "STANDARD_IA"
    }

    noncurrent_version_transition {
      noncurrent_days = 60
      storage_class   = "GLACIER"
    }

    status = "Enabled"
  }
}