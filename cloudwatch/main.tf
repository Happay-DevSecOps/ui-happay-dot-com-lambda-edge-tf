resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/lambda/${local.name_prefix}-function"
  retention_in_days = 30
  kms_key_id = var.kms_key_id
  tags 			=   merge(var.tags, tomap({
                            "description" = "${local.name_prefix} Logs",
                            "Name" = "/aws/lambda/${local.name_prefix}-function"}))
}
