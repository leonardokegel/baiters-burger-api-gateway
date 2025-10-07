data "aws_vpc" "existing" {
  id = var.vpc_id
}

data "aws_lambda_function" "existing_lambda_authorizer" {
  function_name = "BaitersBurger-LambdaAuthorizer"
}

data "aws_lambda_function" "existing_lambda_authenticator" {
  function_name = "BaitersBurger-LambdaCognito"
}

data "aws_iam_role" "existing_lambda_role" {
  name = "LabRole"
}