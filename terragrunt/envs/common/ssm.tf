
resource "aws_ssm_parameter" "google_oauth_client_id" {
  name  = "/google_oauth/client_id"
  type  = "SecureString"
  value = "dummy"

  lifecycle {
    ignore_changes = [value]
  }
}


resource "aws_ssm_parameter" "google_oauth_client_secret" {
  name  = "/google_oauth/client_secret"
  type  = "SecureString"
  value = "dummy"

  lifecycle {
    ignore_changes = [value]
  }
}

output "ssm_google_oauth_client_id" {
  value = aws_ssm_parameter.google_oauth_client_id.name
}

output "ssm_google_oauth_client_secret" {
  value = aws_ssm_parameter.google_oauth_client_secret.name
}
