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
          # "ecr:ListImages",
          # "ecr:DescribeImages",
          # "ecr:GetRepositoryPolicy"
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

# resource "aws_iam_role" "cross_account_ecr_role" {
#   name = "CrossAccountECRAccessRole"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           AWS = "arn:aws:iam::other-account-id:root"
#         },
#         Action = "sts:AssumeRole"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ecr_cross_account_attach" {
#   role       = aws_iam_role.cross_account_ecr_role.name
#   policy_arn = aws_iam_policy.ecr_cross_account_access.arn
# }

output "jenkins_ecr_policy_arn" {
  value = aws_iam_policy.read_only_access_jenkins.arn
}
