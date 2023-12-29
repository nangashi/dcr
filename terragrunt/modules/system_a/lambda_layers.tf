locals {
  layer_zip_path = "./lambda/layers/layer.zip"
}

data "external" "lambda_layer" {
  program = ["./lambda/layers/create_lambda_layer.sh", "3.9", "./lambda/layers/requirements.txt"]
  # program = ["bash", "-c", "pwd > /tmp/tmp.log"]
}

data "archive_file" "lambda_layer" {
  type             = "zip"
  output_path      = local.layer_zip_path
  source_dir       = data.external.lambda_layer.result.path
  output_file_mode = "0644"
}

resource "aws_lambda_layer_version" "main" {
  layer_name          = "system_a_layer-${var.env}"
  filename            = data.archive_file.lambda_layer.output_path
  compatible_runtimes = ["python3.9"]
  source_code_hash    = data.archive_file.lambda_layer.output_base64sha256
}
