variable "s3_bucket_name" {
  type    = string
  default = "bucket-tf-20-18"
}

variable "versioning_status" {
  type    = string
  default = "Enabled"
}

variable "lifecycle_configuration" {
  type    = string
  default = "Enabled"
}
