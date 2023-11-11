locals {
  env = "dev"
  # アカウント
  account = "384081048358"
  # システム名
  system = "dcr"
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
