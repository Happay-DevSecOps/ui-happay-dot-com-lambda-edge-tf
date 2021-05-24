data "archive_file" "file" {
  type        = "zip"
  source_file = "${path.module}/src/lambda_function.py"
  output_path = "${path.module}/src/lambda_function.zip"
}

resource "aws_lambda_function" "function" {
  filename         = data.archive_file.file.output_path
  function_name    = "${local.name_prefix}-function"
  role             = var.iam_role_arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.7"
  timeout          = "60"
  publish = true

  environment {
    variables = {
      CLOUDWATCH_LOG_GROUP_ARN = var.cloudwatch_log_group_arn,
     }
   }

  tags 			=   merge(var.tags, map(
                            "description","${local.name_prefix} Lambda function",
                            "Name", "${local.name_prefix}-function"))
}

resource "aws_ssm_parameter" "lambda_function_arn" {
  name        = "/hpy/${local.environ}/${local.project}/lambda_function_arn"
  description = "${local.name_prefix} lambda_function_arn"
  type        = "String"
  value       = aws_lambda_function.function.arn

  tags 			=   merge(var.tags, map(
                            "description","${local.name_prefix} param store",
                            "Name", "${local.name_prefix}-function"))
}
