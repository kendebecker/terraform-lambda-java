resource "aws_lambda_function" "tips-stream-listener-tips-lambda" {
  function_name = "${var.app_name}-${var.lang_prefix}-tips-stream-listener"

  filename      = "${var.tips_stream_listener_lambda_payload_filename}"
  source_code_hash = "${filebase64sha256(var.tips_stream_listener_lambda_payload_filename)}"

  # "main" is the filename within the zip file (index.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "${var.tips_stream_listener_lambda_function_handler}"
  runtime = "${var.lambda_runtime}"
  memory_size = 512
  timeout = 30

  role = "${aws_iam_role.lambda_role.arn}"

  tracing_config {
    mode = "Active"
  }

  environment {
    variables = {
      REGION = "${var.region}"
    }
  }
}

resource "aws_lambda_event_source_mapping" "dynamodb-stream-invoke-listener-lambda" {
  event_source_arn  = "${aws_dynamodb_table.codingtips-dynamodb-table.stream_arn}"
  function_name     = "${aws_lambda_function.tips-stream-listener-tips-lambda.arn}"
  starting_position = "LATEST"
  enabled = true
  batch_size = 1
}


