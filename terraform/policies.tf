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

resource "aws_iam_role_policy" "cloudwatch-lambda-policy" {
  name = "${var.app_name}-cloudwatch-lambda-policy"
  role = "${aws_iam_role.lambda_role.id}"
  policy = "${data.aws_iam_policy_document.api-gateway-logs-policy-document.json}"
}

data "aws_iam_policy_document" "api-gateway-logs-policy-document" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents"
    ]
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


data "aws_iam_policy" "aws_xray_write_only_access" {
  arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}
resource "aws_iam_role_policy_attachment" "aws_xray_write_only_access" {
  role       = "${aws_iam_role.lambda_role.id}"
  policy_arn = "${data.aws_iam_policy.aws_xray_write_only_access.arn}"
}

