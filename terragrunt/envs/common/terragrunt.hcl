locals {
  # アカウント
  account = "384081048358"
  # システム名
  system = "dcr"
}

terraform {
  source = "."
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "terraform-remote-state-${local.account}"
    key            = "common/common.tfstate"
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
    }
  }
}
  EOF
}

inputs = merge(local, {
})
