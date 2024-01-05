locals {
  program_path  = "./lambda/monthly_aggregate"
  function_name = "MonthlyAggregate"
}

module "monthly_aggregate" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 6.0"

  timeout             = 900
  function_name       = "${local.function_name}-${var.env}"
  handler             = "main.lambda_handler"
  runtime             = "python3.9"
  create_sam_metadata = true

  create_package         = false
  local_existing_package = data.archive_file.lambda.output_path
  # source_path         = "./lambda/monthly_aggregate/src/"
  # s3_bucket           = module.lambda_source.s3_bucket_id
  # s3_prefix           = "monthly_aggregate/"
  # store_on_s3         = true

  layers = [
    aws_lambda_layer_version.main.arn
  ]
  # package_type        = "Image"
  # publish             = true
  # allowed_triggers = {
  #   APIGatewayAny = {
  #     service    = "apigateway"
  #     source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
  #   }
  # }
}

data "archive_file" "lambda" {
  type             = "zip"
  source_dir       = "${local.program_path}/src"
  output_path      = "${local.program_path}/lambda.zip"
  output_file_mode = "0644"
}
