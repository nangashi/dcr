skip = true

include "root" {
  path = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../..//modules/${path_relative_to_include()}"
}

dependency "infrastructure" {
  config_path = "../infrastructure"
}

dependency "network" {
  config_path = "../network"
}

inputs = {
  # from network
  vpc_id = dependency.network.outputs.vpc_id
  subnet_ids = dependency.network.outputs.private_subnet_ids
  elb_hostname = dependency.network.outputs.elb_hostname
  elb_arn = dependency.network.outputs.elb_arn
  # from infrastructure
  ssm_google_oauth_client_id = dependency.infrastructure.outputs.ssm_google_oauth_client_id
  ssm_google_oauth_client_secret = dependency.infrastructure.outputs.ssm_google_oauth_client_secret
  # jenkins configuration
  jenkins_theme_color = "red"
  ecr_immutable = false
}
