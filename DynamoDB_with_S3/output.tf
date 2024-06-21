output "s3_bucket_arn" {
  value       = aws_s3_bucket.bucket-tf.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.dynamodb-terraform-state-lock.name
  description = "The name of the DynamoDB table"
}
