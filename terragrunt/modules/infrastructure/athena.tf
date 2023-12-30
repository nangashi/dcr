locals {
  catalog_db_name = "catalog_db_${var.env}"
}

resource "aws_athena_workgroup" "athena_search" {
  name = "AthenaSearch-${var.env}"

  configuration {
    enforce_workgroup_configuration    = true
    publish_cloudwatch_metrics_enabled = true

    result_configuration {
      output_location = "s3://${aws_s3_bucket.athena_query_output.bucket}/"

      # encryption_configuration {
      #   encryption_option = "SSE_KMS"
      #   kms_key_arn       = aws_kms_key.example.arn
      # }
    }
  }
}


# # Athenaのデータベースの設定
# resource "aws_athena_database" "cloudtrail_db" {
#   name   = "cloudtrail_db"
#   bucket = aws_s3_bucket.athena_database.id

#   depends_on = [aws_s3_bucket.athena_database]
# }

resource "aws_s3_bucket" "athena_query_output" {
  bucket = "athena-query-output-384081048358-${var.env}"
}

resource "aws_s3_bucket_versioning" "athena_query_output" {
  bucket = aws_s3_bucket.athena_query_output.id
  versioning_configuration {
    status = "Enabled"
  }

  depends_on = [aws_s3_bucket.athena_query_output]
}

resource "aws_s3_bucket_policy" "athena_query_output" {
  bucket = aws_s3_bucket.athena_query_output.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "athena.amazonaws.com"
        }
        Action = [
          "s3:PutObject",
          "s3:GetBucketLocation"
        ]
        Resource = [
          "${aws_s3_bucket.athena_query_output.arn}/*",
          aws_s3_bucket.athena_query_output.arn
        ]
      }
    ]
  })

  depends_on = [aws_s3_bucket.athena_query_output]
}

resource "aws_s3_bucket_lifecycle_configuration" "athena_query_output" {
  bucket = aws_s3_bucket.athena_query_output.id
  rule {
    id = "cleaning"

    expiration {
      days = 7
    }

    noncurrent_version_expiration {
      noncurrent_days = 3
    }

    status = "Enabled"
  }

  depends_on = [aws_s3_bucket.athena_query_output]
}

resource "aws_glue_catalog_database" "catalog_db" {
  name = local.catalog_db_name
}
