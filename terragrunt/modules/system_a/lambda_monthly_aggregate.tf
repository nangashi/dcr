locals {
  program_path  = "./lambda/monthly_aggregate"
  function_name = "MonthlyAggregate"
}

module "monthly_aggregate" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "6.5.0"

  timeout             = 900
  function_name       = "${local.function_name}-${var.env}"
  handler             = "main.lambda_handler"
  runtime             = "python3.9"
  create_sam_metadata = true

  create_package         = false
  local_existing_package = data.archive_file.lambda.output_path
  # source_path         = "./lambda/monthly_aggregate/src/"
  # s3_bucket           = module.lambda_source.s3_bucket_id
  # s3_prefix           = "monthly_aggregate/"
  # store_on_s3         = true

  layers = [
    module.requirements_layer.arn,
    var.common_layer_arn
  ]
  # package_type        = "Image"
  # publish             = true
  # allowed_triggers = {
  #   APIGatewayAny = {
  #     service    = "apigateway"
  #     source_arn = "${aws_apigatewayv2_api.api.execution_arn}/*/*"
  #   }
  # }

  # dead_letter_target_arn = var.sns_notification_topic_arn
  # destination_on_failure = var.sns_notification_topic_arn
  # attach_policy_json     = true
  # policy_json = jsonencode({
  #   Version = "2012-10-17"
  #   Statement = [
  #     {
  #       Effect = "Allow"
  #       # Principal = {
  #       #   Service = "lambda.amazonaws.com"
  #       # }
  #       Action = [
  #         "sns:Publish"
  #       ]
  #       Resource = [
  #         var.sns_notification_topic_arn
  #       ]
  #     }
  #   ]
  # })
}

resource "aws_cloudwatch_metric_alarm" "lambda_alarm" {
  alarm_name          = "lambda-errors-alarm"
  alarm_description   = "Errors alarm for the lambda function"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  actions_enabled     = "true"
  alarm_actions       = [var.sns_notification_topic_arn]
  ok_actions          = [var.sns_notification_topic_arn]
  treat_missing_data  = "notBreaching"
  dimensions = {
    FunctionName = module.monthly_aggregate.lambda_function_name
  }
}

# resource "aws_cloudwatch_event_rule" "lambda_error_rule" {
#   name        = "lambda-error-rule"
#   description = "Capture errors from Lambda functions"

#   event_pattern = jsonencode({
#     source      = ["aws.lambda"]
#     detail-type = ["Lambda Function Invocation Result"]
#     detail = {
#       requestContext = {
#         condition = ["Error"]
#       }
#     }
#   })
# }

# resource "aws_cloudwatch_event_target" "lambda_error_target" {
#   rule = aws_cloudwatch_event_rule.lambda_error_rule.name
#   arn  = var.sns_notification_topic_arn

#   input_transformer {
#     input_paths = {
#       function-name = "$.detail.requestContext.functionName"
#       error-message = "$.detail.errorMessage"
#     }

#     input_template = "\"Function <function-name> encountered an error: <error-message>\""
#   }
# }

data "archive_file" "lambda" {
  type             = "zip"
  source_dir       = "${local.program_path}/src"
  output_path      = "${local.program_path}/lambda.zip"
  output_file_mode = "0644"
}



# # test

# resource "aws_cloudwatch_event_rule" "example_event_rule" {
#   name        = "example-event-rule"
#   description = "Capture events from CloudWatch Alarms"

#   event_pattern = <<PATTERN
# {
#   "source": [
#     "aws.cloudwatch"
#   ]
# }
# PATTERN
# }

# # EventBridgeルールとCloudWatch Logsのターゲットの関連付け
# resource "aws_cloudwatch_event_target" "example_event_target" {
#   rule      = aws_cloudwatch_event_rule.example_event_rule.name
#   target_id = "SendToCloudWatchLogs"
#   arn       = aws_cloudwatch_log_group.example_log_group.arn
# }

# # CloudWatch Logsグループの設定
# resource "aws_cloudwatch_log_group" "example_log_group" {
#   name = "/aws/events/example-log-group"
# }

# # EventBridgeルールのターゲットにIAMロールの設定
# resource "aws_iam_role" "eventbridge_logs_role" {
#   name = "eventbridge-logs-role"

#   assume_role_policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "events.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# POLICY
# }

# resource "aws_iam_role_policy" "eventbridge_logs_policy" {
#   name   = "eventbridge-logs-policy"
#   role   = aws_iam_role.eventbridge_logs_role.id
#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": [
#         "logs:CreateLogStream",
#         "logs:PutLogEvents"
#       ],
#       "Resource": [
#         "${aws_cloudwatch_log_group.example_log_group.arn}"
#       ]
#     }
#   ]
# }
# POLICY
# }

# # IAMロールのEventBridgeルールのターゲットへの割り当て
# resource "aws_cloudwatch_event_target" "example_event_target_with_role" {
#   target_id = "SendToCloudWatchLogsWithRole"
#   arn       = aws_cloudwatch_log_group.example_log_group.arn
#   rule      = aws_cloudwatch_event_rule.example_event_rule.name
#   # role_arn  = aws_iam_role.eventbridge_logs_role.arn
# }
