include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../..//modules/${path_relative_to_include()}"
}

inputs = {
  envs = ["dev", "prd"]
}
