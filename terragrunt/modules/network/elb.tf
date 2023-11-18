# ALBにセキュリティグループを関連付ける
resource "aws_lb" "dc_elb" {
  name               = "dc-lb-${var.env}"
  internal           = false
  load_balancer_type = "application"
  subnets            = [ for key, subnet in aws_subnet.public : subnet.id ]
  security_groups    = [aws_security_group.dc_elb.id]
}

resource "aws_security_group" "dc_elb" {
  name        = "jenkins-alb-sg-${var.env}"
  description = "Allow inbound traffic from the Internet to the ALB"
  vpc_id      = aws_vpc.dc_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # ここは適宜制限をかけることをお勧めします
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "jenkins_elb" {
  name     = "jenkins-tg-${var.env}"
  port     = 8080
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = aws_vpc.dc_vpc.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    path                = "/"
    interval            = 30
    matcher             = "200"
  }
}

resource "aws_lb_listener" "jenkins_elb" {
  load_balancer_arn = aws_lb.dc_elb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = ""
      status_code = "403"
    }
    # target_group_arn = aws_lb_target_group.jenkins_elb.arn
  }
}

resource "aws_lb_listener_rule" "jenkins_elb" {
  listener_arn = aws_lb_listener.jenkins_elb.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_elb.arn
  }

  condition {
    path_pattern {
      values = ["/jenkins*"]
    }
  }
}

output "dns_name" {
  value = aws_lb.dc_elb.dns_name
}

output "jenkins_target_group_arn" {
  value = aws_lb_target_group.jenkins_elb.arn
}
