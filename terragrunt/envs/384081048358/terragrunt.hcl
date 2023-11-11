locals {
  # アカウント
  account = "384081048358"
  # システム名
  system = "dcr"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = "terraform-remote-state-${local.account}"
    key            = "${local.account}/${path_relative_to_include()}.tfstate"
    region         = "ap-northeast-1"
    encrypt        = true
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}

skip = true

inputs = merge(local, {
})
