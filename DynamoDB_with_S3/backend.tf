terraform {
  backend "s3" {
    bucket = "bucket-tf-20-18"
    key    = "global/s3/terraform.tfstate"
    region = "us-east-2"

    dynamodb_table = "terraform-state-lock-dynamo"
    encrypt        = true
  }
}
