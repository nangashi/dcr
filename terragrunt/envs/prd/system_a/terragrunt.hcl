include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../..//modules/${path_relative_to_include()}"
}

dependency "infrastructure" {
  config_path = "../infrastructure"
}

inputs = {
  common_layer_arn           = dependency.infrastructure.outputs.common_layer_arn
  sns_notification_topic_arn = dependency.infrastructure.outputs.sns_notification_topic_arn
}
