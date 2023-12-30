locals {
  github_openid_url               = "https://token.actions.githubusercontent.com"
  github_openid_configuration_url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

data "tls_certificate" "github_actions" {
  url = local.github_openid_configuration_url
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url             = local.github_openid_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github_actions.certificates[0].sha1_fingerprint]
}

# GitHub ActionsからはこのIAM Roleを指定する
resource "aws_iam_role" "administrator" {
  for_each = toset(var.envs)

  name               = "AdministratorOidc-${each.value}"
  assume_role_policy = data.aws_iam_policy_document.administrator.json
  description        = "IAM Role for GitHub Actions OIDC"
}

# see: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#configuring-the-role-and-trust-policy
data "aws_iam_policy_document" "administrator" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.github_actions.arn
      ]
    }

    # OIDCを利用できるGitHub Repositoryを制限する
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_user}/${var.github_repository}:environment:production"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "administrator" {
  for_each = toset(var.envs)

  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.administrator[each.key].name
}

# GitHub Actions側からはこのIAM Roleを指定する
resource "aws_iam_role" "read_only" {
  for_each = toset(var.envs)

  name               = "ReadOnlyOidc-${each.value}"
  assume_role_policy = data.aws_iam_policy_document.read_only.json
  description        = "IAM Role for GitHub Actions OIDC"
}

# see: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#configuring-the-role-and-trust-policy
data "aws_iam_policy_document" "read_only" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity",
    ]

    principals {
      type = "Federated"
      identifiers = [
        aws_iam_openid_connect_provider.github_actions.arn
      ]
    }

    # OIDCを利用できるGitHub Repositoryを制限する
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_user}/${var.github_repository}:environment:development"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "read_only" {
  for_each = toset(var.envs)

  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  role       = aws_iam_role.read_only[each.key].name
}
