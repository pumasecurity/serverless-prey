resource "random_string" "panther_storage_flag_name" {
  count = var.configure_ctf ? 1 : 0

  length  = 8
  special = false
  upper   = false
  lower   = true
  numeric = true
}

resource "random_uuid" "panther_storage_flag" {
  count = var.configure_ctf ? 1 : 0
}

resource "aws_s3_bucket" "panther" {
  count = var.configure_ctf ? 1 : 0

  bucket        = "panther-${random_string.panther_storage_flag_name[0].id}"
  force_destroy = true
  tags          = var.global_tags
}

resource "aws_s3_object" "panther" {
  count = var.configure_ctf ? 1 : 0

  bucket = aws_s3_bucket.panther[0].bucket
  key    = "panther.jpg"
  source = "${path.module}/../../assets/panther.jpg"

  tags = {
    flag = base64encode("${var.flag_prefix}{${random_uuid.panther_storage_flag[0].id}}")
  }
}
