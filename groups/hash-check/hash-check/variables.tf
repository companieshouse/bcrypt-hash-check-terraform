variable "aws_account" {
  type        = string
  description = "The AWS account name"
}

variable "aws_account_id" {
  type        = string
  description = "The AWS account identifier"
}

variable "aws_profile" {
  type        = string
  description = "The AWS profile name; used as a prefix for Vault secrets"
}

variable "region" {
  type        = string
  description = "The AWS region in which resources will be created"
}

variable "environment" {
  type        = string
  description = "The environment name to be used when creating AWS resources"
}

variable "service" {
  type        = string
  description = "The service name to be used when creating AWS resources"
}

variable "lambda_handler_name" {
  type        = string
  description = "The lambda function entrypoint"
}

variable "lambda_logs_retention_days" {
  type        = number
  description = "The number of days to retain Lambda logs in CloudWatch"
}

variable "lambda_memory_size" {
  type        = string
  description = "The amount of memory made available to the Lambda function at runtime in megabytes"
}

variable "lambda_timeout_seconds" {
  type        = string
  description = "The amount of time the lambda function is allowed to run before being stopped"
}

variable "lambda_runtime" {
  type        = string
  description = "The lambda runtime to use for the function"
}

variable "release_bucket_name" {
  type        = string
  description = "The name of the S3 bucket containing the release artefact for the Lambda function"
}

variable "release_artifact_key" {
  type        = string
  description = "The release artifact key for the Lambda function"
}