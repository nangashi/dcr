include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../..//modules/${path_relative_to_include()}"
}

dependency "common" {
  config_path = "../../common"
}

dependency "network" {
  config_path = "../network"
}

inputs = {
  vpc_id = dependency.network.outputs.vpc_id
  public_subnet_ids = dependency.network.outputs.public_subnet_ids
  private_subnet_ids = dependency.network.outputs.private_subnet_ids
  target_group_arn = dependency.network.outputs.jenkins_target_group_arn

  jenkins_theme_color = "blue"
  jenkins_host = dependency.network.outputs.dns_name
  google_oauth_client_id = dependency.common.outputs.ssm_google_oauth_client_id
  google_oauth_client_secret = dependency.common.outputs.ssm_google_oauth_client_secret
}
