locals {
  env = "dev"
  # アカウント
  account = "384081048358"
  # システム名
  system = "dcr"

  git_repository = "https://github.com/nangashi/dcr.git"
  git_branch = "feature/jenkins"

  jenkins_prefix = "/jenkins"
}

dependency "common" {
  config_path = "../../common"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "terraform-remote-state-${local.account}"
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
  jenkins_ecr_policy_arn = dependency.common.outputs.jenkins_ecr_policy_arn
})
