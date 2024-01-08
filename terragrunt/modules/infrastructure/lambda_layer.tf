# locals {
#   program_path = "./lambda/layers"
# }

# data "archive_file" "lambda_layer" {
#   type             = "zip"
#   source_dir       = "${local.program_path}/src"
#   output_path      = "${local.program_path}/lambda.zip"
#   output_file_mode = "0644"
# }


# resource "aws_lambda_layer_version" "lambda_layer" {
#   layer_name          = "common_layer-${var.env}"
#   filename            = data.archive_file.lambda_layer.output_path
#   compatible_runtimes = ["python3.9"]
#   source_code_hash    = data.archive_file.lambda_layer.output_base64sha256
# }

module "common_layer" {
  source      = "../custom/layer"
  layer_name  = "common_layer-${var.env}"
  runtime     = "python3.9"
  source_path = "./lambda/common_layer/src"
}

output "common_layer_arn" {
  value = module.common_layer.arn
}
