data "aws_region" "current" {}

resource "aws_s3_bucket" "s3-log" {
  bucket = "${local.name_prefix}-logs-${data.aws_region.current.name}"

  acl    = "private"

  lifecycle_rule {
    id      = "glacier-700"
    enabled = true

    transition {
      days          = 60
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 120
      storage_class = "GLACIER"
    }

    expiration {
      days = 180
     }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.kms_key_arn
        sse_algorithm     = "aws:kms"
      }
    }
 }

 tags                  =   merge(var.tags, map(
                            "description","${local.name_prefix} Logs",
                            "Name", "${local.name_prefix}-logs-${data.aws_region.current.name}"))
}
