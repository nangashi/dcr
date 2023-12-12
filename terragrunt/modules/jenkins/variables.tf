# from base
variable "system" {
  description = "システム名"
  type        = string
}
variable "env" {
  description = "環境名"
  type        = string
}

# from infrastructure
variable "ssm_google_oauth_client_id" {
  type = string
}
variable "ssm_google_oauth_client_secret" {
  type = string
}

# from network
variable "vpc_id" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}
variable "elb_arn" {
  type = string
}
variable "elb_hostname" {
  type = string
}

# jenkins parameter
variable "ecr_immutable" {
  type = bool
}
variable "github_repository_url" {
  type = string
}
variable "github_branch" {
  type = string
}
variable "current_tag" {
  type = string
}
variable "jenkins_theme_color" {
  type = string
}
variable "jenkins_url_prefix" {
  type = string
}
