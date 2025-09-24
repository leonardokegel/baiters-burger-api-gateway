resource "aws_api_gateway_rest_api" "api" {
  name        = "${var.project_name}-api"
  description = "API para o sistema do Baiters Burger"

  body = file("${path.module}/openapi.yaml")

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  triggers = {
    redeployment = sha1(file("${path.module}/openapi.yaml"))
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "v1"
}