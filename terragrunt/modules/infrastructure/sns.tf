resource "aws_sns_topic" "notification_sns_topic" {
  name = "SlackNotification-${var.env}"
}

resource "aws_sns_topic_policy" "notification_sns_topic" {
  arn    = aws_sns_topic.notification_sns_topic.arn
  policy = data.aws_iam_policy_document.notification_sns_topic.json
}

data "aws_iam_policy_document" "notification_sns_topic" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type = "Service"
      identifiers = [
        "events.amazonaws.com",
        "cloudwatch.amazonaws.com"
      ]
    }

    resources = [aws_sns_topic.notification_sns_topic.arn]
  }
}

# AWS Chatbot Slack Channel Configuration
resource "awscc_chatbot_slack_channel_configuration" "notification_chatbot" {
  configuration_name = "Chatbot-${var.env}"

  # Slack ワークスペース ID とチャンネル ID を設定
  slack_workspace_id = var.chatbot_slack_workspace_id
  slack_channel_id   = var.chatbot_slack_channel_id

  # SNS トピック ARN を設定
  sns_topic_arns = [aws_sns_topic.notification_sns_topic.arn]

  # IAM ロール ARN を設定
  iam_role_arn = aws_iam_role.notification_chatbot.arn

  # ログインフォメーション設定（任意）
  logging_level      = "ERROR"
  guardrail_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

resource "aws_iam_role" "notification_chatbot" {
  name = "ChatBotChannelRole-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "chatbot.amazonaws.com"
        }
      },
    ]
  })

  inline_policy {
    name = "SubscribeSnsTopic"
    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = [
            "sns:Subscribe"
          ]
          Resource = [aws_sns_topic.notification_sns_topic.arn]
        }
      ]
    })
  }

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchReadOnlyAccess"
  ]
}

# 出力 (オプション)
output "sns_notification_topic_arn" {
  value = aws_sns_topic.notification_sns_topic.arn
}
