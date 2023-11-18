variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "jenkins_ecr_policy_arn" {
  type = string
}

variable "docker_image" {
  type = string
}

variable "jenkins_theme_color" {
  type = string
}
