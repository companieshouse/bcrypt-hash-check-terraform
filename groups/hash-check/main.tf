
provider "aws" {
  region  = var.region
  version = "~> 2.50.0"
}

provider "vault" {
  auth_login {
    path = "auth/userpass/login/${var.vault_username}"

    parameters = {
      password = var.vault_password
    }
  }
}

terraform {
  backend "s3" {
  }
}

data "aws_caller_identity" "current" {}

module "hash_check" {
  source = "./hash-check"

  aws_account                           = var.aws_account
  aws_account_id                        = data.aws_caller_identity.current.account_id
  aws_profile                           = var.aws_profile
  environment                           = var.environment
  lambda_handler_name                   = var.lambda_handler_name
  lambda_logs_retention_days            = var.lambda_logs_retention_days
  lambda_memory_size                    = var.lambda_memory_size
  lambda_runtime                        = var.lambda_runtime
  lambda_timeout_seconds                = var.lambda_timeout_seconds
  region                                = var.region
  release_artifact_key                  = var.release_artifact_key
  release_bucket_name                   = var.release_bucket_name
  service                               = var.service
}