# IAMグループを作成
resource "aws_iam_group" "example_group" {
  name = "example-group"
}

# 作成済みのIAMポリシーをIAMグループにアタッチ
resource "aws_iam_group_policy_attachment" "example_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess" # 任意のポリシーARNを設定
  group      = aws_iam_group.example_group.name
}

data "aws_iam_policy_document" "mfa_required" {
  statement {
    actions   = ["*"]
    resources = ["*"]
    effect    = "Deny"

    condition {
      test     = "Bool"
      variable = "aws:MultiFactorAuthPresent"
      values   = ["false"]
    }
  }
}

resource "aws_iam_policy" "mfa_required_policy" {
  name        = "MFARequiredPolicy"
  description = "Policy that requires MFA"
  policy      = data.aws_iam_policy_document.mfa_required.json
}

resource "aws_iam_group_policy_attachment" "mfa_required_policy" {
  policy_arn = aws_iam_policy.mfa_required_policy.arn
  group      = aws_iam_group.example_group.name
}
