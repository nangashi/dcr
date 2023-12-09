# # ALBにセキュリティグループを関連付ける
# resource "aws_lb" "dc_elb" {
#   name               = "elb-${var.system}-${var.env}"
#   internal           = false
#   load_balancer_type = "application"
#   subnets            = [for key, subnet in aws_subnet.public : subnet.id]
#   security_groups    = [aws_security_group.dc_elb.id]
# }

# resource "aws_security_group" "dc_elb" {
#   name        = "elb-${var.system}-${var.env}"
#   description = "Allow inbound traffic from the Internet to the ALB"
#   vpc_id      = aws_vpc.dc_vpc.id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["118.158.0.0/16"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

output "elb_hostname" {
  # value = aws_lb.dc_elb.dns_name
  value = ""
}

output "elb_arn" {
  # value = aws_lb.dc_elb.arn
  value = ""
}
