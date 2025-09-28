data "aws_cognito_user_pools" "all_pools" {
  name = "BaitersBurger_CognitoUserPool"
}

locals {
  pool_id = one(data.aws_cognito_user_pools.all_pools.ids)
}

data "aws_cognito_user_pool_clients" "clients" {
  user_pool_id = local.pool_id
}

locals {
  machine_client_index = index(data.aws_cognito_user_pool_clients.clients.client_names, "BaitersBurgerAppClient")
  machine_client_id = data.aws_cognito_user_pool_clients.clients.client_ids[local.machine_client_index]
}