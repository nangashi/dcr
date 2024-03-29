locals {
  env = "dev"
  # アカウント
  account_id = "384081048358"
  # システム名
  system = "dcr"

  github_user           = "nangashi"
  github_repository     = "dcr"
  github_repository_url = "https://github.com/${local.github_user}/${local.github_repository}.git"
  github_branch         = "feature/jenkins"

  slack_webhook_url = "https://hooks.slack.com/services/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"
}

remote_state {
  backend = "s3"
  config = {
    bucket  = "terraform-remote-state-${local.account_id}"
    key     = "${local.env}/${path_relative_to_include()}.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }

  generate = {
    path      = "_backend.tf"
    if_exists = "overwrite"
  }
}

generate "provider" {
  path      = "_provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  required_version = ">= 1.6.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    awscc = {
      source  = "hashicorp/awscc"
      version = "0.29.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Environment = "${local.env}"
    }
  }
}

provider "awscc" {
  region = "ap-northeast-1"
}
  EOF
}

skip = true

inputs = merge(local, {
})
