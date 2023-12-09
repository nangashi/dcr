locals {
  env = "prd"
  # アカウント
  account_id = "384081048358"
  # システム名
  system = "dcr"

  git_repository = "https://github.com/nangashi/dcr.git"
  git_branch = "main"

  slack_webhook_url = "https://hooks.slack.com/services/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"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "terraform-remote-state-${local.account_id}"
    key            = "${local.env}/${path_relative_to_include()}.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
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
  required_version = "= 1.6.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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
  EOF
}

skip = true

inputs = merge(local, {
})
