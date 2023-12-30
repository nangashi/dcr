variable "env" {
  description = "環境名"
  type        = string
}

# from base
variable "envs" {
  description = "環境名のリスト"
  type        = list(string)
}

variable "github_user" {
  description = "デプロイ元となるGitHubユーザ名"
  type        = string
}

variable "github_repository" {
  description = "デプロイ元となるGitHubリポジトリ名"
  type        = string
}
