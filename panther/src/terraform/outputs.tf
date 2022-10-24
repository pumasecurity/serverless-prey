output "panther_function_url" {
  description = "Panther function URL endpoint"
  value       = aws_lambda_function_url.panther.function_url
}

output "panther_function_api_key" {
  description = "Panther function API key"
  value       = random_string.panther_api_key.id
}
