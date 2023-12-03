resource "aws_efs_file_system" "jenkins_efs" {
  creation_token   = "jenkins-ecs-${var.env}" # 作成トークンを任意の値に設定してください
  performance_mode = "generalPurpose"         # パフォーマンスモードを設定 (generalPurpose | maxIO)
  throughput_mode  = "bursting"               # スループットモードを設定 (bursting | provisioned)
  encrypted        = true

  lifecycle_policy {
    transition_to_ia = "AFTER_1_DAY"
  }

  tags = {
    Name = "jenkins-efs-${var.system}-${var.env}" # タグを任意の値に設定してください
  }
}

resource "aws_efs_mount_target" "jenkins_efs" {
  file_system_id  = aws_efs_file_system.jenkins_efs.id
  subnet_id       = var.private_subnet_ids[0]
  security_groups = [aws_security_group.jenkins_efs.id]
}

resource "aws_security_group" "jenkins_efs" {
  name   = "jenkins-efs-${var.env}"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = ["${aws_security_group.jenkins_ecs.id}"]
  }
}

data "aws_iam_policy_document" "jenkins_efs" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = ["*"]
    resources = [
      aws_efs_file_system.jenkins_efs.arn
    ]

    # resources = [aws_efs_file_system.jenkins_efs.arn]
    condition {
      test     = "Bool"
      variable = "elasticfilesystem:AccessedViaMountTarget"
      values   = ["true"]
    }
  }
}

resource "aws_efs_file_system_policy" "jenkins_efs" {
  file_system_id = aws_efs_file_system.jenkins_efs.id
  policy         = data.aws_iam_policy_document.jenkins_efs.json
}

resource "aws_efs_access_point" "jenkins_efs" {
  file_system_id = aws_efs_file_system.jenkins_efs.id
  root_directory {
    path = "/jenkins_home"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = "755"
    }
  }
}

resource "aws_iam_policy" "jenkins_efs_mount" {
  name = "jenkins-task-policy-${var.env}" # ポリシー名を指定してください

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
