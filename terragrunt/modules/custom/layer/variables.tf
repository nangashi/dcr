variable "runtime" {
  description = "ビルドするpythonのランタイムバージョン。python3.9, python3.10など"
  type        = string
}

variable "source_path" {
  description = "layerのソースを配置しているパス"
  type        = string
}

variable "layer_name" {
  description = "作成するレイヤーの名称"
  type        = string
}
