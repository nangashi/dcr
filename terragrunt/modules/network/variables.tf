variable "account" {}
variable "env" {}

variable "vpc_cidr_block" {
  type = string
}

variable "public_subnets" {
  type = map(
    object({
      cidr_block = string
      availability_zone = string
    }
  ))
}
variable "private_subnets" {
  type = map(
    object({
      cidr_block = string
      availability_zone = string
    }
  ))
}

variable "jenkins_prefix" {
  type = string
}
