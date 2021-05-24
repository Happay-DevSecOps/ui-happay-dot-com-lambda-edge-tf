/* DEFAULT VARIABLES */

variable "tags" {
  type = map
}
locals {
  environ = var.tags["Environ"]
  project = var.tags["Project"]
}

variable "meta" {
  type = map
}
locals {
  name_prefix = var.meta["name_prefix"]
  region_name = var.meta["region_name"]
}

/* CUSTOM VARIABLES */

variable "workspace" { type = map }
variable "kms_key_arn" { type = string }
variable "iam_role_arn" { type = string }
variable "cloudwatch_log_group_arn" { type = string }
