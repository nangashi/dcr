# ECSクラスターの定義.
resource "aws_ecs_cluster" "jenkins_ecs" {
  name = "jenkins-cluster-${var.system}-${var.env}"
}

# Jenkins用のECSタスク定義
resource "aws_ecs_task_definition" "jenkins_ecs" {
  family                 = "jenkins"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.jenkins_ecs_execution.arn
  task_role_arn            = aws_iam_role.jenkins_task_execution.arn
  cpu                      = 2048
  memory                   = 4096

  container_definitions = jsonencode([{
    name      = "jenkins"
    image     = "${aws_ecr_repository.jenkins_ecr.repository_url}:${var.current_tag}"
    essential = true
    portMappings = [{
      containerPort = 8080
      hostPort      = 8080
    }]

    environment = [
      { name = "JENKINS_OPTS", value = "--prefix=${var.jenkins_url_prefix}" },
      { name = "JENKINS_THEME_COLOR", value = var.jenkins_theme_color },
      { name = "JENKINS_URL", value = "http://${var.elb_hostname}${var.jenkins_url_prefix}" },
      { name = "GIT_REPOSITORY", value = var.git_repository },
      { name = "GIT_BRANCH", value = var.git_branch },
      { name = "GOOGLE_OAUTH2_CLIENT_ID", value = data.aws_ssm_parameter.google_oauth_client_id.value },
      { name = "GOOGLE_OAUTH2_CLIENT_SECRET", value = data.aws_ssm_parameter.google_oauth_client_secret.value },
    ]

    mountPoints = [{
      sourceVolume  = aws_efs_file_system.jenkins_efs.name
      containerPath = "/var/jenkins_home"
    }]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.jenkins_ecs_log.name
        awslogs-region        = "ap-northeast-1"
        awslogs-stream-prefix = "jenkins-ecs-${var.system}-${var.env}"
      }
    }
  }])

  volume {
    name = "jenkins-efs-${var.system}-${var.env}"

    efs_volume_configuration {
      file_system_id          = aws_efs_file_system.jenkins_efs.id
      root_directory          = "/"
      transit_encryption      = "ENABLED"
      transit_encryption_port = 2049
      authorization_config {
        access_point_id = aws_efs_access_point.jenkins_efs.id
        iam             = "ENABLED"
      }
    }
  }
}

# ECSサービスにELBを関連付けるための設定
resource "aws_ecs_service" "jenkins_ecs" {
  name            = "jenkins-service-${var.system}-${var.env}"
  cluster         = aws_ecs_cluster.jenkins_ecs.id
  task_definition = aws_ecs_task_definition.jenkins_ecs.arn
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.jenkins_elb.arn
    container_name   = "jenkins"
    container_port   = 8080
  }

  network_configuration {
    subnets         = [var.private_subnet_ids[0]]
    security_groups = [aws_security_group.jenkins_ecs.id]
    # assign_public_ip = true
  }

  desired_count = 1
  depends_on = [
    aws_cloudwatch_log_group.jenkins_ecs_log
  ]
}


# セキュリティグループの定義
resource "aws_security_group" "jenkins_ecs" {
  name        = "jenkins-sg-${var.system}-${var.env}"
  description = "Allow Jenkins"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ssm_parameter" "google_oauth_client_id" {
  name = var.ssm_google_oauth_client_id
}

data "aws_ssm_parameter" "google_oauth_client_secret" {
  name = var.ssm_google_oauth_client_secret
}

output "jenkins_url" {
  value = "http://${var.elb_hostname}${var.jenkins_url_prefix}/"
}
