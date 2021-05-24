terraform {
  required_providers {
    aws = {
      version = ">= 3.25.0"
      source = "hashicorp/aws"
    }
  }
  backend "s3" {}
}

variable "s3_bucket_name" {}
variable "key" {}
variable "region" {}
variable "project" {}
variable "environ" {}
