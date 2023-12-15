# 管理者ユーザ
resource "aws_iam_user" "administrator" {
  for_each = (var.env == "dev") ? toset(var.administrator_users) : []
  name     = each.value
  path     = "/"
}

resource "aws_iam_role" "administrator" {
  name = "Administrator-${var.env}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          AWS = [for user in var.administrator_users : "arn:aws:iam::${var.user_account_id}:user/${user}"]
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
  depends_on = [
    aws_iam_user.administrator
  ]
}

resource "aws_iam_role_policy_attachment" "administrator" {
  role       = aws_iam_role.administrator.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  depends_on = [
    aws_iam_role.administrator
  ]
}

# dev環境以外ではAdministratorロール利用時に通知する
resource "aws_cloudwatch_event_rule" "administrator_notification" {
  count          = (var.env != "dev") ? 1 : 0
  name           = "AssumeAdministratorRole-${var.env}"
  event_bus_name = "default"

  event_pattern = jsonencode({
    source      = ["aws.sts"]
    detail-type = ["AWS API Call via CloudTrail"]
    detail = {
      eventName = ["AssumeRole"],
      requestParameters = {
        roleArn = [aws_iam_role.administrator.arn]
      }
    }
  })
}

resource "aws_cloudwatch_event_target" "administrator_notification" {
  count = (var.env != "dev") ? 1 : 0
  rule  = aws_cloudwatch_event_rule.administrator_notification[0].name
  arn   = aws_sns_topic.notification_sns_topic.arn
}


resource "aws_iam_user" "developer" {
  for_each = (var.env == "dev") ? toset(var.developer_users) : []
  name     = each.value
  path     = "/"
}

resource "aws_iam_role" "developer" {
  name = "Developer-${var.env}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          AWS = [for user in var.developer_users : "arn:aws:iam::${var.user_account_id}:user/${user}"]
        }
        Effect = "Allow"
        Sid    = ""
      }
    ]
  })
  depends_on = [
    aws_iam_user.developer
  ]
}

resource "aws_iam_role_policy_attachment" "developer_read_only" {
  count      = (var.env != "dev") ? 1 : 0
  role       = aws_iam_role.developer.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  depends_on = [
    aws_iam_role.developer
  ]
}

resource "aws_iam_role_policy_attachment" "developer_operator" {
  count      = (var.env != "dev") ? 1 : 0
  role       = aws_iam_role.developer.name
  policy_arn = aws_iam_policy.operator.arn
  depends_on = [
    aws_iam_role.developer,
    aws_iam_policy.operator
  ]
}

resource "aws_iam_role_policy_attachment" "developer_poweruser" {
  count      = (var.env == "dev") ? 1 : 0
  role       = aws_iam_role.developer.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
  depends_on = [
    aws_iam_role.developer
  ]
}

resource "aws_iam_group" "users" {
  count = (var.env == "dev") ? 1 : 0
  name  = "Users-${var.env}"
}

resource "aws_iam_group_membership" "users" {
  count = (var.env == "dev") ? 1 : 0
  name  = "UsersMembership"
  users = concat(var.administrator_users, var.developer_users)
  group = aws_iam_group.users[0].name
  depends_on = [
    aws_iam_user.administrator,
    aws_iam_user.developer
  ]
}

resource "aws_iam_group_policy" "users_mfa_only" {
  count  = (var.env == "dev") ? 1 : 0
  name   = "MFAOnlyPolicy"
  group  = aws_iam_group.users[0].name
  policy = data.aws_iam_policy_document.mfa_only.json
  depends_on = [
    aws_iam_group.users
  ]
}

resource "aws_iam_group_policy_attachment" "users_read_only" {
  count      = (var.env == "dev") ? 1 : 0
  group      = aws_iam_group.users[0].name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  depends_on = [
    aws_iam_group.users
  ]
}

resource "aws_iam_group_policy_attachment" "users_operator" {
  count      = (var.env == "dev") ? 1 : 0
  group      = aws_iam_group.users[0].name
  policy_arn = aws_iam_policy.operator.arn
  depends_on = [
    aws_iam_group.users,
    aws_iam_policy.operator
  ]
}

resource "aws_iam_policy" "operator" {
  name        = "Operator-${var.env}"
  description = "Policy with additional permissions"
  policy      = data.aws_iam_policy_document.operator.json
}

data "aws_iam_policy_document" "operator" {
  version = "2012-10-17"

  statement {
    actions = [
      "lambda:InvokeFunction",
      "datapipeline:ActivatePipeline",
      "sqs:PurgeQueue",
    ]
    resources = ["*"]
    effect    = "Allow"
  }
}

data "aws_iam_policy_document" "mfa_only" {
  version = "2012-10-17"

  statement {
    sid    = "AllowListActions"
    effect = "Allow"

    actions = [
      "iam:ListUsers",
      "iam:ListVirtualMFADevices",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "AllowUserToCreateVirtualMFADevice"
    effect = "Allow"

    actions = [
      "iam:CreateVirtualMFADevice",
    ]

    resources = ["arn:aws:iam::*:mfa/*"]
  }

  statement {
    sid    = "AllowUserToManageTheirOwnMFA"
    effect = "Allow"

    actions = [
      "iam:EnableMFADevice",
      "iam:GetMFADevice",
      "iam:ListMFADevices",
      "iam:ResyncMFADevice",
    ]

    resources = ["arn:aws:iam::*:user/$${aws:username}"]
  }

  statement {
    sid    = "AllowUserToDeactivateTheirOwnMFAOnlyWhenUsingMFA"
    effect = "Allow"

    actions = [
      "iam:DeactivateMFADevice",
    ]

    resources = ["arn:aws:iam::*:user/$${aws:username}"]

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["true"]
    }
  }

  statement {
    sid    = "BlockMostAccessUnlessSignedInWithMFA"
    effect = "Deny"

    not_actions = [
      "iam:CreateVirtualMFADevice",
      "iam:EnableMFADevice",
      "iam:ListMFADevices",
      "iam:ListUsers",
      "iam:ListVirtualMFADevices",
      "iam:ResyncMFADevice",
    ]

    resources = ["*"]

    condition {
      test     = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["false"]
    }
  }
}
