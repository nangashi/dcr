include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../..//modules/${path_relative_to_include()}"
}

inputs = {
  vpc_cidr_block = "10.1.0.0/16"
  public_subnets = {
    subnet1 = {
      cidr_block        = "10.1.1.0/24"
      availability_zone = "ap-northeast-1a"
    },
    subnet2 = {
      cidr_block        = "10.1.2.0/24"
      availability_zone = "ap-northeast-1c"
    }
  }
  private_subnets = {
    subnet1 = {
      cidr_block        = "10.1.3.0/24"
      availability_zone = "ap-northeast-1a"
    },
    subnet2 = {
      cidr_block        = "10.1.4.0/24"
      availability_zone = "ap-northeast-1c"
    }
  }
}
