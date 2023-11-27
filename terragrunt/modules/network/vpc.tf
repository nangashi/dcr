# VPCの作成
resource "aws_vpc" "dc_vpc" {
  cidr_block = var.vpc_cidr_block # VPCのCIDRブロックを指定
  enable_dns_hostnames = true

  tags = {
    "Name" = "vpc-${var.env}"
  }
}

# パブリックサブネット
resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id     = aws_vpc.dc_vpc.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = {
    Name = "sbn-public-${var.env}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.dc_vpc.id
  tags = {
    Name = "rtb-public-${var.system}-${var.env}"
  }
}

resource "aws_route_table_association" "public" {
  count       = length(var.public_subnets)
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[keys(var.public_subnets)[count.index]].id
}


# プライベートサブネット
resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id     = aws_vpc.dc_vpc.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = {
    Name = "sbn-public-${var.system}-${var.env}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.dc_vpc.id
  tags = {
    Name = "rtb-private-${var.system}-${var.env}"
  }
}

resource "aws_route_table_association" "private" {
  count       = length(var.private_subnets)
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[keys(var.private_subnets)[count.index]].id
}


output "vpc_id" {
  value = aws_vpc.dc_vpc.id
}

output "public_subnet_ids" {
  value = [ for key, subnet in aws_subnet.public : subnet.id ]
}

output "private_subnet_ids" {
  value = [ for key, subnet in aws_subnet.private : subnet.id ]
}
