output "api_invoke_url" {
  description = "URL base para invocar a API."
  value       = aws_api_gateway_stage.api_stage.invoke_url
}