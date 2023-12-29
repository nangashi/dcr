# resource "aws_lambda_function" "test_lambda" {
#   # If the file is not in the current working directory you will need to include a
#   # path.module in the filename.
#   filename      = "lambda_function_payload.zip"
#   function_name = "lambda_function_name"
#   role          = aws_iam_role.iam_for_lambda.arn
#   handler       = "index.test"

#   source_code_hash = data.archive_file.lambda.output_base64sha256

#   runtime = "nodejs18.x"

#   environment {
#     variables = {
#       foo = "bar"
#     }
#   }
# }

module "monthly_aggregate" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 6.0"

  timeout             = 900
  source_path         = "./monthly_aggregate/src/"
  function_name       = "MonthlyAggregate-${var.env}"
  handler             = "main.lambda_handler"
  runtime             = "python3.8"
  create_sam_metadata = true
  s3_bucket           = module.lambda_source.s3_bucket_id
  s3_prefix           = "monthly_aggregate/"
  store_on_s3         = true
  # publish             = true
  # allowed_triggers = {
  #   APIGatewayAny = {
  #     service    = "apigateway"
  #     source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
  #   }
  # }
}
