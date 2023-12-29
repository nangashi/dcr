# resource "aws_iam_role" "iam_for_lambda" {
#   name               = "SystemALambda-${var.env}"
#   assume_role_policy = data.aws_iam_policy_document.assume_role.json
# }

locals {
  bucket_name = "system-a-source-${var.env}"
}

module "lambda_source" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.0"

  bucket = local.bucket_name
  versioning = {
    enabled = true
  }
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "PutSource"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = [
          "s3:GetObject"
        ]
        Resource = [
          "arn:aws:s3:::${local.bucket_name}",
          "arn:aws:s3:::${local.bucket_name}/*"
        ]
      },
    ]
  })
}
