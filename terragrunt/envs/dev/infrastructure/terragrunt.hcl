include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../..//modules/${path_relative_to_include()}"
}

inputs = {
  chatbot_slack_channel_id = "C067Z3NFCB1"
}
