resource "aws_api_gateway_rest_api" "codingtips-api-gateway" {
  name        = "${var.app_name}-${var.lang_prefix}-API"
  description = "API to access codingtips application"
  body        = "${data.template_file.codingtips_api_swagger.rendered}"
}

data "template_file" codingtips_api_swagger{
  template = "${file("swagger.yaml")}"

  vars {
    get_lambda_arn = "${aws_lambda_function.get-tips-lambda.invoke_arn}"
    post_lambda_arn = "${aws_lambda_function.post-tips-lambda.invoke_arn}"
  }
}

resource "aws_api_gateway_deployment" "codingtips-api-gateway-deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.codingtips-api-gateway.id}"
  stage_name  = "default"
}


resource "aws_api_gateway_method_settings" "settings" {
  rest_api_id = "${aws_api_gateway_rest_api.codingtips-api-gateway.id}"
  stage_name  = "${aws_api_gateway_deployment.codingtips-api-gateway-deployment.stage_name}"
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
    throttling_burst_limit = 10
    throttling_rate_limit = 10
  }
}

output "url" {
  value = "${aws_api_gateway_deployment.codingtips-api-gateway-deployment.invoke_url}/api"
}

output "post_lambda_arn" {
  value = "${aws_lambda_function.post-tips-lambda.invoke_arn}"
}

