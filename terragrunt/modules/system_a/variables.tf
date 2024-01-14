# from base
variable "env" {
  description = "環境名"
  type        = string
}

variable "common_layer_arn" {
  description = "共通ライブラリのlayerのARN"
  type        = string
}

variable "sns_notification_topic_arn" {
  description = "通知用SNSトピックのARN"
  type        = string
}
