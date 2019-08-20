variable "lambda_version"     {default = "1.0.0"}

variable "scanlimit"         {default = "100"}

variable "lang_prefix"        {default = "java"}

variable "app_name"           {default = "CodingTips"}

variable "region"             {default = "eu-west-1"}

variable "account_id"         {default = ""}

variable "get_lambda_payload_filename" {
  default = "../get-lambda/target/get-lambda-1.0.0-SNAPSHOT.jar"
}

variable "get_lambda_function_handler" {
  default = "GetLambda::handleRequest"
}

variable "post_lambda_payload_filename" {
  default = "../post-lambda/target/post-lambda-1.0.0-SNAPSHOT.jar"
}

variable "post_lambda_function_handler" {
  default = "PostLambda::handleRequest"
}

variable "tips_stream_listener_lambda_payload_filename" {
  default = "../tips-stream-listener-lambda/target/tips-stream-listener-lambda-1.0.0-SNAPSHOT.jar"
}

variable "tips_stream_listener_lambda_function_handler" {
  default = "TipsStreamListenerLambda::handleRequest"
}

variable "lambda_runtime" {
  default = "java8"
}
