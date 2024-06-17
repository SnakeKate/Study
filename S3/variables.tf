variable "s3_bucket_name" {
  type = string
  default = "my-tf-test-bucket-kate-snake"
}

variable "my-versioning-bucket" {
  type = string
  default = "my-tf-test-versioning-bucket"
}

variable "enabled" {
  # false create bucket with versioning and lifecycle
  # true create bucket only whith lifecycle
  type    = bool
  default = false
}