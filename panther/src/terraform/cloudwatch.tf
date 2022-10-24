resource "aws_cloudwatch_log_group" "panther" {
  name              = "/aws/lambda/${aws_lambda_function.panther.function_name}"
  retention_in_days = 7
  tags              = var.global_tags
}
