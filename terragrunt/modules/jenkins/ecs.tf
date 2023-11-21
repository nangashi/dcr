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

resource "aws_iam_policy" "jenkins_ecs" {
  name        = "jenkins-ecs-task-logs-policy-${var.env}"  # ポリシー名を指定してください
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
        Resource = "arn:aws:logs:*:*:log-group:${aws_cloudwatch_log_group.jenkins_ecs.name}:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_ecs" {
  policy_arn = aws_iam_policy.jenkins_ecs.arn
  role       = aws_iam_role.jenkins_ecs_execution.name
}

resource "aws_iam_role_policy_attachment" "jenkins_ecr" {
  policy_arn = var.jenkins_ecr_policy_arn
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

resource "aws_iam_policy" "jenkins_task" {
  name        = "jenkins-task-policy-${var.env}"  # ポリシー名を指定してください

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "elasticfilesystem:ClientMount",
          "elasticfilesystem:ClientWrite",
        ],
        Resource = aws_efs_access_point.jenkins_efs.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_task" {
  policy_arn = aws_iam_policy.jenkins_task.arn
  role       = aws_iam_role.jenkins_task_execution.name
}

resource "aws_cloudwatch_log_group" "jenkins_ecs" {
  name = "/ecs/jenkins-ecs-${var.env}"
  retention_in_days = 14
}

# Jenkins用のECSタスク定義
resource "aws_ecs_task_definition" "jenkins_ecs" {
  family                   = "jenkins"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.jenkins_ecs_execution.arn
  task_role_arn = aws_iam_role.jenkins_task_execution.arn
  cpu                      = 1024
  memory                   = 2048

  container_definitions = jsonencode([{
    name  = "jenkins"
    # image = "jenkins/jenkins:lts"
    image = var.docker_image
    essential = true
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
    }]

    environment = [
      { name = "JENKINS_OPTS", value = "--prefix=${var.jenkins_prefix}" },
      { name = "JENKINS_THEME_COLOR", value = var.jenkins_theme_color },
      { name = "JENKINS_URL", value = "http://${var.jenkins_host}${var.jenkins_prefix}" },
      { name = "GIT_REPOSITORY", value = var.git_repository },
      { name = "GIT_BRANCH", value = var.git_branch },
      { name = "GOOGLE_OAUTH2_CLIENT_ID", value = data.aws_ssm_parameter.google_oauth_client_id.value },
      { name = "GOOGLE_OAUTH2_CLIENT_SECRET", value = data.aws_ssm_parameter.google_oauth_client_secret.value },
    ]

    mountPoints = [{
      sourceVolume  = "jenkins-data-${var.env}"
      containerPath = "/var/jenkins_home"
    }]

    logConfiguration  = {
      logDriver = "awslogs"
      options = {
        awslogs-group = aws_cloudwatch_log_group.jenkins_ecs.name
        awslogs-region = "ap-northeast-1"
        awslogs-stream-prefix = "jenkins-ecs-${var.env}"
      }
    }
  }])

  volume {
    name = "jenkins-data-${var.env}"

    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.jenkins_efs.id
      root_directory          = "/"
      transit_encryption      = "ENABLED"
      transit_encryption_port = 2049
      authorization_config {
        access_point_id = aws_efs_access_point.jenkins_efs.id
        iam = "ENABLED"
      }
    }
  }
}

# ECSクラスターの定義
resource "aws_ecs_cluster" "jenkins_ecs" {
  name = "jenkins-cluster-${var.env}"
}

# ECSサービスにELBを関連付けるための設定
resource "aws_ecs_service" "jenkins_ecs" {
  name            = "jenkins-service-${var.env}"
  cluster         = aws_ecs_cluster.jenkins_ecs.id
  task_definition = aws_ecs_task_definition.jenkins_ecs.arn
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "jenkins"
    container_port   = 8080
  }

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [aws_security_group.jenkins_ecs.id]
    # assign_public_ip = true
  }

  desired_count = 1
  depends_on = [
    aws_cloudwatch_log_group.jenkins_ecs
  ]
}


# セキュリティグループの定義
resource "aws_security_group" "jenkins_ecs" {
  name        = "jenkins-sg-${var.env}"
  description = "Allow Jenkins"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      cidr_blocks     = ["0.0.0.0/0"]
  }
}

data "aws_ssm_parameter" "google_oauth_client_id" {
  name = var.google_oauth_client_id
}

data "aws_ssm_parameter" "google_oauth_client_secret" {
  name = var.google_oauth_client_secret
}

# # セキュリティグループの定義
# resource "aws_security_group" "jenkins_ecs_task" {
#   name        = "jenkins-sg-${var.env}"
#   description = "Allow Jenkins"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port   = 2375
#     to_port     = 2375
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]  # 注意: セキュリティが重要な場合は制限を緩めないでください
#   }
# }

output "jenkins_url" {
  value = "http://${var.jenkins_host}${var.jenkins_prefix}"
}
