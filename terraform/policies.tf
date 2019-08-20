# POLICIES
resource "aws_iam_role_policy" "dynamodb-lambda-policy" {
  name = "${var.app_name}_dynamodb_lambda_policy"
  role = "${aws_iam_role.lambda_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:*"
      ],
      "Resource": "${aws_dynamodb_table.codingtips-dynamodb-table.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "dynamodb-stream-lambda-policy" {
  name = "${var.app_name}_dynamodb_stream_lambda_policy"
  role = "${aws_iam_role.lambda_role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
          "dynamodb:DescribeStream",
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator",
          "dynamodb:ListStreams"
      ],
      "Resource": "${aws_dynamodb_table.codingtips-dynamodb-table.stream_arn}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch-lambda-policy-python" {
  name = "${var.app_name}-cloudwatch-lambda-policy"
  role = "${aws_iam_role.lambda_role.id}"
  policy = "${data.aws_iam_policy_document.api-gateway-logs-policy-document-python.json}"
}

data "aws_iam_policy_document" "api-gateway-logs-policy-document-python" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ],
    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}


resource "aws_iam_role_policy" "api-gateway-lambda-policy" {
  name = "${var.app_name}_api_gateway_lambda_policy"
  role = "${aws_iam_role.api_gateway_role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "lambda:InvokeFunction",
            "Resource": "*"
        }
    ]
}
EOF
}


resource "aws_iam_role_policy" "lambda-xray-policy" {
  name = "${var.app_name}_lambda_xray_policy"
  role = "${aws_iam_role.lambda_role.id}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "xray:PutTraceSegments",
              "xray:PutTelemetryRecords"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}