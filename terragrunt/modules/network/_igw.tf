# resource "aws_internet_gateway" "dc_igw" {
#   vpc_id = aws_vpc.dc_vpc.id
#   tags = {
#     Name = "igw-${var.system}-${var.env}"
#   }
# }

# resource "aws_route" "igw" {
#   route_table_id         = aws_route_table.public.id
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.dc_igw.id
#   depends_on             = [aws_route_table.public]
# }

# resource "aws_nat_gateway" "nat_gateway" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.public["subnet1"].id
#   tags = {
#     Name = "nat-${var.system}-${var.env}"
#   }
# }

# resource "aws_eip" "nat_eip" {
#   domain = "vpc"

#   tags = {
#     Name = "eip-nat-${var.system}-${var.env}"
#   }
# }

# resource "aws_route" "private_route_to_nat" {
#   route_table_id         = aws_route_table.private.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat_gateway.id
# }
