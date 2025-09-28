data "aws_iam_role" "existing_lambda_role" {
  name = "LabRole"
}

data "archive_file" "lambda_authorizer_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda-authorizer"
  output_path = "${path.module}/lambda-authorizer.zip"
}

resource "aws_lambda_function" "api_authorizer" {
  function_name = "${var.project_name}-token-validator"
  filename      = data.archive_file.lambda_authorizer_zip.output_path
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  role = data.aws_iam_role.existing_lambda_role.arn

  source_code_hash = data.archive_file.lambda_authorizer_zip.output_base64sha256

  environment {
    variables = {
      COGNITO_USER_POOL_ID  = local.pool_id
      COGNITO_REGION        = "us-east-1"
      COGNITO_APP_CLIENT_ID = local.machine_client_id
    }
  }
}

resource "aws_lambda_permission" "api_gateway_authorizer_invoke" {
  statement_id  = "AllowAPIGatewayToInvokeAuthorizer"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.api_authorizer.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/authorizers/*"
}