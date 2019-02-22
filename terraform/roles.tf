resource "aws_iam_role" "api_gateway_role" {
  name = "${var.app_name}-${var.lang_prefix}-api-gateway"
  assume_role_policy = "${data.aws_iam_policy_document.api_gateway_assumerole_policy_document.json}"
}

data "aws_iam_policy_document" "api_gateway_assumerole_policy_document" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "apigateway.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "${var.app_name}-${var.lang_prefix}-lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_role" "cloudwatch_role" {
  name = "${var.app_name}-${var.lang_prefix}-cloudwatch"
  assume_role_policy = "${data.aws_iam_policy_document.cloudwatch_assumerole_policy_document.json}"
}

data "aws_iam_policy_document" "cloudwatch_assumerole_policy_document" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "logs.us-east-1.amazonaws.com"
      ]
    }
  }
}
