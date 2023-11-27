resource "aws_ecr_repository" "jenkins_ecr" {
  name                 = "jenkins"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_iam_policy" "jenkins_ecr_read_only_access" {
  name        = "ECRReadOnlyAccessForJenkins"
  description = "Policy to allow read-only access to a specific ECR repository"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
        ],
        Resource = aws_ecr_repository.jenkins_ecr.arn
      },
      {
        Effect = "Allow",
        Action = "ecr:GetAuthorizationToken",
        Resource = "*"
      }
    ]
  })
}
