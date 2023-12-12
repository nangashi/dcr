# from base
variable "env" {
  description = "環境名"
  type        = string
}

variable "github_branch" {
  description = "デプロイ元となるGitHubブランチ名"
  type        = string
}

variable "github_user" {
  description = "デプロイ元となるGitHubユーザ名"
  type        = string
}

variable "github_repository" {
  description = "デプロイ元となるGitHubリポジトリ名"
  type        = string
}
