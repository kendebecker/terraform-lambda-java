resource "aws_lambda_function" "post-tips-lambda" {
  function_name = "${var.app_name}-${var.lang_prefix}-post"

  filename      = "${var.post_lambda_payload_filename}"
  source_code_hash = "${base64sha256(file(var.post_lambda_payload_filename))}"

  # "main" is the filename within the zip file (index.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "${var.post_lambda_function_handler}"
  runtime = "${var.lambda_runtime}"
  memory_size = 512
  timeout = 30

  role = "${aws_iam_role.lambda_role.arn}"

  tracing_config {
    mode = "Active"
  }

  environment {
    variables {
      SCANLIMIT = "${var.scanlimit}"
      REGION = "${var.region}"
    }
  }
}

resource "aws_lambda_permission" "api-gateway-invoke-post-lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.post-tips-lambda.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.codingtips-api-gateway-deployment.execution_arn}/*/*"
}



