# IAMユーザーを作成
resource "aws_iam_user" "example_user" {
  name = "example-user"
}

# IAMユーザーをIAMグループに追加
resource "aws_iam_user_group_membership" "example_membership" {
  user    = aws_iam_user.example_user.name
  groups  = [aws_iam_group.example_group.name]
}
