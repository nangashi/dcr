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
