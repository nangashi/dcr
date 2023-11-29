resource "aws_cloudwatch_log_group" "jenkins_ecs_log" {
  name              = "/ecs/jenkins-ecs-${var.env}"
  retention_in_days = 14
}

resource "aws_iam_policy" "jenkins_ecs_log" {
  name        = "jenkins-ecs-task-logs-policy-${var.env}" # ポリシー名を指定してください
  description = "IAM policy for ECS task to write logs to CloudWatch Logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:log-group:${aws_cloudwatch_log_group.jenkins_ecs_log.name}:*"
      }
    ]
  })
}
