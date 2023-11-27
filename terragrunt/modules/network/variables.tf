# from base
variable "system" {}
variable "env" {}

# network configuration
variable "vpc_cidr_block" {}

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
