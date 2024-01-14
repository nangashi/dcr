#
# EventBridgeのイベントをCloudWatch Logsに保存する
#

locals {
  eventbridge_logs_sources = ["aws.cloudwatch"]
}

# 記録対象のイベントを定義
resource "aws_cloudwatch_event_rule" "eventbridge_logs" {
  count = var.enable_eventbridge_log ? 1 : 0

  name        = "EventBridgeMessageLogs-${var.env}"
  description = "Record EventBridge Event Message in CloudWatch Logs"

  event_pattern = jsonencode({
    source : local.eventbridge_logs_sources
  })
}

# EventBridgeルールとCloudWatch Logsのターゲットの関連付け
resource "aws_cloudwatch_event_target" "eventbridge_logs" {
  count = var.enable_eventbridge_log ? 1 : 0

  rule      = aws_cloudwatch_event_rule.eventbridge_logs[0].name
  target_id = "SendToCloudWatchLogs-${var.env}"
  arn       = aws_cloudwatch_log_group.eventbridge_logs[0].arn
}

# CloudWatch Logsグループの設定
resource "aws_cloudwatch_log_group" "eventbridge_logs" {
  count = var.enable_eventbridge_log ? 1 : 0

  name = "/aws/events/${var.env}/message-logs"
}
