resource "aws_lb_listener" "jenkins_elb" {
  load_balancer_arn = var.elb_arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = ""
      status_code = "403"
    }
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
      values = ["${var.jenkins_url_prefix}*"]
    }
  }
}

# Google Loginを入れるとヘルスチェックで403になるため、403は正常なレスポンスとみなす
resource "aws_lb_target_group" "jenkins_elb" {
  name     = "jenkins-tg-${var.env}"
  port     = 8080
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 5
    timeout             = 10
    path                = "${var.jenkins_url_prefix}/"
    interval            = 30
    matcher             = "200-299,403"
  }
}
