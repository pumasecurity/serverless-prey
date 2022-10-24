resource "random_string" "panther_api_key" {
  length  = 32
  special = false
  upper   = true
  lower   = true
  numeric = true
}

resource "random_uuid" "panther_config_flag" {
  count = var.configure_ctf ? 1 : 0
}

data "template_file" "panther_config" {
  template = file("${path.module}/../../assets/config.tpl")
  vars = {
    database_password = var.configure_ctf ? "${var.flag_prefix}{${random_uuid.panther_config_flag[0].id}}" : "RG9ncyBhcmUgb3VyIGxpbmsgdG8gcGFyYWRpc2UuIFRoZXkgZG9u4oCZdCBrbm93IGV2aWwgb3IgamVhbG91c3kgb3IgZGlzY29udGVudC4="
    storage_bucket    = "panther-${var.configure_ctf ? random_string.panther_storage_flag_name[0].id : var.unique_identifier}"
  }
}

resource "local_file" "panther_config" {
  filename = "${path.module}/../panther/config.json"
  content  = data.template_file.panther_config.rendered
}

data "archive_file" "panther_build" {
  depends_on = [
    local_file.panther_config
  ]

  type        = "zip"
  source_dir  = "${path.module}/../panther"
  output_path = "${path.module}/../panther.zip"
}

resource "aws_lambda_function" "panther" {
  depends_on = [
    aws_secretsmanager_secret_version.panther
  ]

  function_name    = "serverless-prey-panther-${var.unique_identifier}"
  description      = "Serverless Prey function for execution environment inspection."
  runtime          = "nodejs16.x"
  timeout          = 60
  memory_size      = 512
  handler          = "handler.panther"
  role             = aws_iam_role.panther.arn
  filename         = "${path.module}/../panther.zip"
  source_code_hash = data.archive_file.panther_build.output_base64sha256

  environment {
    variables = {
      PANTHER_SECRET_ARN = var.configure_ctf ? aws_secretsmanager_secret.panther[0].arn : ""
      PANTHER_API_KEY    = random_string.panther_api_key.id
    }
  }

  tags = var.global_tags
}

resource "aws_lambda_function_url" "panther" {
  function_name      = aws_lambda_function.panther.function_name
  authorization_type = "NONE"
}
