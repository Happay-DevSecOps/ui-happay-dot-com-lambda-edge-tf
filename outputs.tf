output "cloudwatch_log_group_arn" {
  value       = module.cloudwatch.cloudwatch_log_group_arn
}

output "s3_log_bucket_id" {
  value       = module.s3.s3_log_bucket_id
}

output "iam_role_arn" {
  value       = module.iam.iam_role_arn
}