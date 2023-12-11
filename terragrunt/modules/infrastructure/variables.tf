# from base
variable "env" {
  description = "環境名"
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
