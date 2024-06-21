resource "aws_s3_bucket" "bucket-tf" {
  bucket = var.s3_bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.bucket-tf.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "bucket-tf" {
  bucket = aws_s3_bucket.bucket-tf.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket-tf" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket-tf]

  bucket = aws_s3_bucket.bucket-tf.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket-tf.id
  versioning_configuration {
    status = var.versioning_status
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "versioning-bucket-config" {

  depends_on = [aws_s3_bucket_versioning.versioning]
  bucket     = aws_s3_bucket.bucket-tf.id

  rule {
    id = "noncurrent_version"

    filter {}

    noncurrent_version_expiration {
      newer_noncurrent_versions = 5
      noncurrent_days           = 10
    }

    status = var.lifecycle_configuration
  }
}
