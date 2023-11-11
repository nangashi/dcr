locals {
  log_group_name = "/ecs/jenkins2-ecs-${var.env}"
}

# ECS Task Execution Role
resource "aws_iam_role" "jenkins_ecs_execution" {
  name = "jenkins2-ecs-execution-${var.env}"

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
  name        = "jenkins2-ecs-task-logs-policy-${var.env}"  # ポリシー名を指定してください
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
          # "logs:*"
        ],
        Resource = "arn:aws:logs:*:*:log-group:${aws_cloudwatch_log_group.jenkins_ecs.name}:*"
        # Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_ecs" {
  policy_arn = aws_iam_policy.jenkins_ecs.arn
  role       = aws_iam_role.jenkins_ecs_execution.name
}

resource "aws_cloudwatch_log_group" "jenkins_ecs" {
  name = local.log_group_name
  retention_in_days = 30
}

# Jenkins用のECSタスク定義
resource "aws_ecs_task_definition" "jenkins_ecs" {
  family                   = "jenkins2"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.jenkins_ecs_execution.arn
  task_role_arn = aws_iam_role.jenkins_ecs_execution.arn
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name  = "jenkins"
    image = "jenkins/jenkins:lts"
    essential = true
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
    }]
    # mountPoints = [{
    #   sourceVolume  = "jenkins-data-${var.env}"
    #   containerPath = "/var/jenkins_home"
    # }]

    logConfiguration  = {
      logDriver = "awslogs"
      options = {
        awslogs-group = aws_cloudwatch_log_group.jenkins_ecs.name
        awslogs-region = "ap-northeast-1"
        awslogs-stream-prefix = "jenkins-ecs-dev"
      }
    }
  }])

  # volume {
  #   name = "jenkins-data-${var.env}"

  #   efs_volume_configuration {
  #     file_system_id          = aws_efs_file_system.jenkins_efs.id
  #     root_directory          = "/"
  #     transit_encryption      = "ENABLED"
  #     transit_encryption_port = 2049
  #   }
  # }
}

# ECSクラスターの定義
resource "aws_ecs_cluster" "jenkins_ecs" {
  name = "jenkins2-cluster-${var.env}"
}

# ECSサービスにELBを関連付けるための設定
resource "aws_ecs_service" "jenkins_ecs" {
  name            = "jenkins2-service-${var.env}"
  cluster         = aws_ecs_cluster.jenkins_ecs.id
  task_definition = aws_ecs_task_definition.jenkins_ecs.arn
  launch_type     = "FARGATE"

  # load_balancer {
  #   target_group_arn = aws_lb_target_group.jenkins_elb.arn
  #   container_name   = "jenkins2"
  #   container_port   = 8080
  # }

  network_configuration {
    # subnets         = var.private_subnet_ids
    subnets         = var.public_subnet_ids
    security_groups = [aws_security_group.jenkins_ecs.id]
    assign_public_ip = true
  }

  desired_count = 1
  depends_on = [
    # aws_lb_listener.jenkins_elb,
    aws_cloudwatch_log_group.jenkins_ecs
  ]
}


# セキュリティグループの定義
resource "aws_security_group" "jenkins_ecs" {
  name        = "jenkins2-sg-${var.env}"
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

