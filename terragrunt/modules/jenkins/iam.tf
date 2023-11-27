# ECS Task Execution Role
resource "aws_iam_role" "jenkins_ecs_execution" {
  name = "jenkins-ecs-execution-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_ecs_log" {
  policy_arn = aws_iam_policy.jenkins_ecs_log.arn
  role       = aws_iam_role.jenkins_ecs_execution.name
}

resource "aws_iam_role_policy_attachment" "jenkins_ecr_read_only_access" {
  policy_arn = aws_iam_policy.jenkins_ecr_read_only_access.arn
  role       = aws_iam_role.jenkins_ecs_execution.name
}

resource "aws_iam_role" "jenkins_task_execution" {
  name = "jenkins-task-execution-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_efs_mount" {
  policy_arn = aws_iam_policy.jenkins_efs_mount.arn
  role       = aws_iam_role.jenkins_task_execution.name
}
