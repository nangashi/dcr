# from base
variable "env" {
  description = "環境名"
  type        = string
}

variable "account_id" {
  description = "アカウントID"
  type        = string
}

variable "administrator_users" {
  description = "管理者ユーザ"
  type        = list(string)
}

variable "developer_users" {
  description = "開発者ユーザ"
  type        = list(string)
}

variable "user_account_id" {
  description = "ユーザを作成するアカウントID"
  type        = string
}

variable "chatbot_slack_workspace_id" {
  description = "Chatbotの通知先となるSlackワークスペースID"
  type        = string
}

variable "chatbot_slack_channel_id" {
  description = "Chatbotの通知先となるSlackチャンネルID"
  type        = string
}

variable "enable_eventbridge_log" {
  description = "EventBridgeで受信したイベントをCloudWatch Logsで保存する"
  type        = bool
}
