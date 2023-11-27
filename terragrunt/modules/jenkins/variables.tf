# from base
variable "system" {}
variable "env" {}

# from infrastructure
variable "ssm_google_oauth_client_id" {}
variable "ssm_google_oauth_client_secret" {}

# from network
variable "vpc_id" {}
variable "public_subnet_ids" {
  type = list(string)
}
variable "private_subnet_ids" {
  type = list(string)
}
variable "elb_arn" {}
variable "elb_hostname" {}

# jenkins parameter
variable "git_repository" {}
variable "git_branch" {}
variable "current_tag" {}
variable "jenkins_theme_color" {}
variable "jenkins_url_prefix" {}

