data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
    effect  = "Allow"
  }
}

data "aws_iam_policy_document" "panther" {

  statement {
    sid    = "AllowCloudWatchLogging"
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
    ]
    resources = [
      "${aws_cloudwatch_log_group.panther.arn}:*",
    ]
  }

  dynamic "statement" {
    for_each = var.configure_ctf ? ["ConfigureCtf"] : []
    content {
      sid    = "AllowReadSecret"
      effect = "Allow"

      actions = [
        "secretsmanager:GetSecretValue",
      ]

      resources = [
        "${aws_secretsmanager_secret.panther[0].arn}*"
      ]
    }
  }

  dynamic "statement" {
    for_each = var.configure_ctf ? ["ConfigureCtf"] : []
    content {
      sid    = "AllowS3ReadObject"
      effect = "Allow"

      actions = [
        "s3:GetObject",
        "s3:GetObjectTagging"
      ]

      resources = [
        "${aws_s3_bucket.panther[0].arn}/*"
      ]
    }
  }
}

resource "aws_iam_role" "panther" {
  name               = "panther-lambda-${var.unique_identifier}-role"
  path               = "/"
  description        = "IAM role for Serverless Prey Panther function"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json

  tags = var.global_tags
}

resource "aws_iam_policy" "panther" {
  name        = "panther-lambda-${var.unique_identifier}-policy"
  path        = "/"
  description = "IAM policy for Serverless Prey Panther function"
  policy      = data.aws_iam_policy_document.panther.json

  tags = var.global_tags
}

resource "aws_iam_role_policy_attachment" "panther" {
  role       = aws_iam_role.panther.name
  policy_arn = aws_iam_policy.panther.arn
}
