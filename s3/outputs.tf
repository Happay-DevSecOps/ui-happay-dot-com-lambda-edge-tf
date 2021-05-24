
output "s3_log_bucket_id" {
  value       = aws_s3_bucket.s3-log.id
}

output "s3_log_bucket_arn" {
  value       = aws_s3_bucket.s3-log.arn
}
