resource "aws_api_gateway_rest_api" "hash_check" {
  name = "${var.service}-${var.environment}"
  description = "API gateway for the bcrypt hash check service"

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  policy = data.aws_iam_policy_document.api_gateway_policy.json
}

data "aws_iam_policy_document" "api_gateway_policy" {

  statement {
    effect = "Allow"
  
    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "execute-api:Invoke"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_api_gateway_resource" "hash_check_resource" {
  rest_api_id = aws_api_gateway_rest_api.hash_check.id
  parent_id   = aws_api_gateway_rest_api.hash_check.root_resource_id
  path_part   = "hashcheck"
}

resource "aws_api_gateway_method" "hash_check_method" {
  rest_api_id   = aws_api_gateway_rest_api.hash_check.id
  resource_id   = aws_api_gateway_resource.hash_check_resource.id
  http_method   = "POST"
  authorization = "AWS_IAM"
  api_key_required = true
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.hash_check.id
  resource_id             = aws_api_gateway_resource.hash_check_resource.id
  http_method             = aws_api_gateway_method.hash_check_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.hash_check.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_integration.integration]

  rest_api_id = aws_api_gateway_rest_api.hash_check.id
}

resource "aws_api_gateway_stage" "stage" {
  stage_name    = var.environment
  rest_api_id   = aws_api_gateway_rest_api.hash_check.id
  deployment_id = aws_api_gateway_deployment.deployment.id
}

resource "aws_api_gateway_api_key" "hash_check_key" {
  name = "${var.service}-${var.environment}-key"
  description = "API key for accessing the ${var.service} gateway, this is auto generated by AWS"
}

resource "aws_api_gateway_usage_plan" "hash_check_usage_plan" {
  name = "${var.service}-${var.environment}-usage-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.hash_check.id
    stage  = aws_api_gateway_stage.stage.stage_name
  }
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.hash_check_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.hash_check_usage_plan.id
}

output "api_key" {
  value = aws_api_gateway_api_key.hash_check_key.value
}