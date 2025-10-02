resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.project_name}-api"
  description = "API para o sistema Baiters Burger"

  body = templatefile("../gateway/openapi-bundled.yaml", {
    vpc_link_id           = aws_api_gateway_vpc_link.eks_nlb_link.id
    nlb_dns_name          = var.nlb_dns_name
    lambda_authorizer_arn = data.aws_lambda_function.existing_lambda_authorizer.arn
    lambda_authenticator_arn = data.aws_lambda_function.existing_lambda_authenticator.arn
  })

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(aws_api_gateway_rest_api.api.body)
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "production"
}

resource "aws_lambda_permission" "api_gateway_authorizer_invoke" {
  statement_id  = "AllowAPIGatewayToInvokeAuthorizer"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.existing_lambda_authorizer.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/authorizers/*"
}

resource "aws_lambda_permission" "api_gateway_integration_invoke" {
  statement_id  = "AllowAPIGatewayToInvokeLoginLambda"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.existing_lambda_authenticator.function_name 
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*" 
}