data "external" "layer" {
  program = ["${path.module}/build.sh", var.runtime, var.source_path]
}

data "archive_file" "layer" {
  type = "zip"
  # output_path      = "${var.source_path}/layer.zip"
  output_path      = "${data.external.layer.result.path}/layer.zip"
  source_dir       = data.external.layer.result.path
  output_file_mode = "0644"
}

resource "aws_lambda_layer_version" "layer" {
  layer_name               = var.layer_name
  filename                 = data.archive_file.layer.output_path
  compatible_runtimes      = [var.runtime]
  compatible_architectures = ["x86_64"]
  source_code_hash         = data.archive_file.layer.output_base64sha256

  # ロファイルパス変更時に差分検知されることを避けるために必要
  lifecycle {
    ignore_changes = [filename]
  }
}

output "arn" {
  value = aws_lambda_layer_version.layer.arn
}
