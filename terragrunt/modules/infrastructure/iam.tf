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

resource "aws_iam_role_policy_attachment" "developer" {
  role       = aws_iam_role.developer.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
  depends_on = [
    aws_iam_role.developer
  ]
}

resource "aws_iam_group" "users" {
  count = (var.env == "dev") ? 1 : 0
  name  = "User"
}

resource "aws_iam_group_membership" "users" {
  count = (var.env == "dev") ? 1 : 0
  name  = "user-membership"
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

resource "aws_iam_group_policy_attachment" "read_only" {
  count      = (var.env == "dev") ? 1 : 0
  group      = aws_iam_group.users[0].name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  depends_on = [
    aws_iam_group.users
  ]
}
