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

# GitHub Actions側からはこのIAM Roleを指定する
resource "aws_iam_role" "github_actions" {
  name               = "github-actions"
  assume_role_policy = data.aws_iam_policy_document.github_actions.json
  description        = "IAM Role for GitHub Actions OIDC"
}

# see: https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#configuring-the-role-and-trust-policy
data "aws_iam_policy_document" "github_actions" {
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

    # OIDCを利用できる対象のGitHub Repositoryを制限する
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        # "repo:${var.github_user}/${var.github_repository}:ref:refs/heads/${var.github_branch}"
        "repo:nangashi/dcr:environment:production"
      ]
    }
  }
}

# 実際に利用する際にはこれに加えてdeny定義を追加付与するなどして、CI/CD用にカスタマイズすることを強く推奨
resource "aws_iam_role_policy_attachment" "github_actions" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.github_actions.name
}
