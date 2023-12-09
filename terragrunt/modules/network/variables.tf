# from base
variable "system" {
  description = "システム名"
  type        = string
}
variable "env" {
  description = "環境名"
  type        = string
}

# == network configuration ==

variable "vpc_cidr_block" {
  description = "vpcで利用するcidrブロック"
  type        = string
}

variable "public_subnets" {
  description = "公開サブネットのcidrブロック"
  type = map(
    object({
      cidr_block        = string
      availability_zone = string
      }
  ))
}

variable "private_subnets" {
  description = "非公開サブネットのcidrブロック"
  type = map(
    object({
      cidr_block        = string
      availability_zone = string
      }
  ))
}
