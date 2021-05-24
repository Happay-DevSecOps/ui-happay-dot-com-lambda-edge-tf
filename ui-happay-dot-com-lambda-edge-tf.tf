module "s3" {
  source = "./s3"
  tags = local.tags
  meta = local.meta
  workspace = local.workspace

  kms_key_arn = local.workspace["kms_key_arn"]
  cloudwatch_log_group_arn = module.cloudwatch.cloudwatch_log_group_arn
}

module "lambda" {
  source = "./s3"
  tags = local.tags
  meta = local.meta
  workspace = local.workspace

  kms_key_arn = local.workspace["kms_key_arn"]
  iam_role_arn = module.iam.iam_role_arn
  cloudwatch_log_group_arn = module.cloudwatch.cloudwatch_log_group_arn
}

module "cloudwatch" {
  source = "./cloudwatch"
  tags = local.tags
  meta = local.meta
  workspace = local.workspace

  kms_key_arn = local.workspace["kms_key_arn"]
}

module "iam" {
  source = "./iam"
  tags = local.tags
  meta = local.meta
  workspace = local.workspace

  s3_log_bucket_arn = module.s3.s3_log_bucket_arn
}
