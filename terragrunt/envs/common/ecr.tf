resource "aws_ecr_repository" "jenkins" {
  name                 = "jenkins"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_iam_policy" "read_only_access_jenkins" {
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
        Resource = aws_ecr_repository.jenkins.arn
      },
      {
        Effect = "Allow",
        Action = "ecr:GetAuthorizationToken",
        Resource = "*"
      }
    ]
  })
}

output "jenkins_ecr_policy_arn" {
  value = aws_iam_policy.read_only_access_jenkins.arn
}
