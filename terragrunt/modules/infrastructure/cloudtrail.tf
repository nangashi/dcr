locals {
  cloudtrail_name               = "CloudTrailForSearch-${var.env}"
  data_catalog_table_name       = "cloudtrail_logs"
  cloudtrail_search_bucket_name = "cloudtrail-log-${var.account_id}-${var.env}"
}

resource "aws_cloudtrail" "cloudtrail_search" {
  name           = local.cloudtrail_name
  s3_bucket_name = aws_s3_bucket.cloudtrail_search.id
  # s3_key_prefix                 = "AWSLogs"
  include_global_service_events = false

  depends_on = [aws_s3_bucket_policy.cloudtrail_search]
}

resource "aws_s3_bucket" "cloudtrail_search" {
  bucket = local.cloudtrail_search_bucket_name
}

resource "aws_s3_bucket_versioning" "cloudtrail_search" {
  bucket = aws_s3_bucket.cloudtrail_search.id
  versioning_configuration {
    status = "Enabled"
  }

  depends_on = [aws_s3_bucket.cloudtrail_search]
}

resource "aws_s3_bucket_policy" "cloudtrail_search" {
  bucket = aws_s3_bucket.cloudtrail_search.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "Acl-Check"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:GetBucketAcl"
        Resource  = aws_s3_bucket.cloudtrail_search.arn
        Condition = {
          StringEquals = {
            "aws:SourceArn" = "arn:aws:cloudtrail:ap-northeast-1:${var.account_id}:trail/${local.cloudtrail_name}"
          }
        }
      },
      {
        Sid       = "S3-Bucket-Write"
        Effect    = "Allow"
        Principal = { Service = "cloudtrail.amazonaws.com" }
        Action    = "s3:PutObject"
        # Resource  = "${aws_s3_bucket.cloudtrail_search.arn}/*"
        Resource = "${aws_s3_bucket.cloudtrail_search.arn}/AWSLogs/${var.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl"  = "bucket-owner-full-control",
            "aws:SourceArn" = "arn:aws:cloudtrail:ap-northeast-1:${var.account_id}:trail/${local.cloudtrail_name}"
          }
        }
      }
    ]
  })

  depends_on = [aws_s3_bucket.cloudtrail_search]
}

resource "aws_s3_bucket_lifecycle_configuration" "cloudtrail_search" {
  bucket = aws_s3_bucket.cloudtrail_search.id
  rule {
    id = "cleaning"

    expiration {
      days = 7
    }

    noncurrent_version_expiration {
      noncurrent_days = 1
    }

    status = "Enabled"
  }

  depends_on = [aws_s3_bucket.cloudtrail_search]
}

# Athenaのテーブルの設定
resource "aws_glue_catalog_table" "cloudtrail_logs" {
  database_name = aws_glue_catalog_database.internal_db.name
  name          = local.data_catalog_table_name

  table_type = "EXTERNAL_TABLE"

  parameters = {
    "EXTERNAL"                           = "true"
    "projection.enabled"                 = "true"
    "projection.timestamp.format"        = "yyyy/MM/dd"
    "projection.timestamp.interval"      = "1"
    "projection.timestamp.interval.unit" = "DAYS"
    "projection.timestamp.range"         = "2021/01/01,NOW"
    "projection.timestamp.type"          = "date"
    "storage.location.template"          = "s3://${aws_s3_bucket.cloudtrail_search.bucket}/AWSLogs/${var.account_id}/CloudTrail/ap-northeast-1/$${timestamp}"
  }

  storage_descriptor {
    location      = "s3://${aws_s3_bucket.cloudtrail_search.bucket}/AWSLogs/${var.account_id}/CloudTrail/ap-northeast-1/"
    input_format  = "com.amazon.emr.cloudtrail.CloudTrailInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"

    ser_de_info {
      name                  = "CloudTrailSerde"
      serialization_library = "com.amazon.emr.hive.serde.CloudTrailSerde"
    }

    columns {
      name = "eventTime"
      type = "string"
    }

    columns {
      name = "eventName"
      type = "string"
    }

    columns {
      name = "eventSource"
      type = "string"
    }

    columns {
      name = "awsRegion"
      type = "string"
    }

    columns {
      name = "sourceIpAddress"
      type = "string"
    }

    columns {
      name = "userAgent"
      type = "string"
    }

    columns {
      name = "errorCode"
      type = "string"
    }

    columns {
      name = "errorMessage"
      type = "string"
    }

    columns {
      name = "userIdentity"
      type = "struct<type:string,principalid:string,arn:string,accountid:string,invokedby:string,accesskeyid:string,username:string,sessioncontext:struct<attributes:struct<mfaauthenticated:string,creationdate:string>,sessionIssuer:struct<type:string,principalId:string,arn:string,accountId:string,userName:string>>>"
    }

    columns {
      name = "requestParameters"
      type = "string"
    }

    columns {
      name = "responseElements"
      type = "string"
    }

    columns {
      name = "additionalEventData"
      type = "string"
    }

    columns {
      name = "resources"
      type = "array<struct<arn:string,accountId:string,type:string>>"
    }

  }

  partition_keys {
    name = "timestamp"
    type = "string"
  }
}
