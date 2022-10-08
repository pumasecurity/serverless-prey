resource "random_uuid" "panther_secret_name" {
  count = var.configure_ctf ? 1 : 0
}

resource "aws_secretsmanager_secret" "panther" {
  count = var.configure_ctf ? 1 : 0

  name        = "panther-${random_uuid.panther_secret_name[0].id}"
  description = "Serverless Prey Panther secret"

  tags = var.global_tags
}

resource "random_uuid" "panther_secret_flag" {
  count = var.configure_ctf ? 1 : 0
}

resource "aws_secretsmanager_secret_version" "panther" {
  count = var.configure_ctf ? 1 : 0

  secret_id     = aws_secretsmanager_secret.panther[0].id
  secret_string = "${var.flag_prefix}{${random_uuid.panther_secret_flag[0].id}}"
}
