<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_awscc"></a> [awscc](#provider\_awscc) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.administrator_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.administrator_notification](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_iam_group.users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group) | resource |
| [aws_iam_group_membership.users](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_membership) | resource |
| [aws_iam_group_policy.users_mfa_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy) | resource |
| [aws_iam_group_policy_attachment.users_operator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_group_policy_attachment.users_read_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_group_policy_attachment) | resource |
| [aws_iam_policy.operator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.administrator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.developer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.administrator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.developer_operator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.developer_poweruser](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.developer_read_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_user.administrator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_iam_user.developer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_user) | resource |
| [aws_sns_topic.notification_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.notification_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_ssm_parameter.google_oauth_client_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.google_oauth_client_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.slack_channel_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.slack_oauth_token](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [awscc_chatbot_slack_channel_configuration.notification_chatbot](https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/chatbot_slack_channel_configuration) | resource |
| [awscc_iam_role.notification_chatbot](https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/iam_role) | resource |
| [aws_iam_policy_document.mfa_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.notification_chatbot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.notification_sns_topic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.operator](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_administrator_users"></a> [administrator\_users](#input\_administrator\_users) | 管理者ユーザ | `list(string)` | n/a | yes |
| <a name="input_chatbot_slack_channel_id"></a> [chatbot\_slack\_channel\_id](#input\_chatbot\_slack\_channel\_id) | Chatbotの通知先となるSlackチャンネルID | `string` | n/a | yes |
| <a name="input_chatbot_slack_workspace_id"></a> [chatbot\_slack\_workspace\_id](#input\_chatbot\_slack\_workspace\_id) | Chatbotの通知先となるSlackワークスペースID | `string` | n/a | yes |
| <a name="input_developer_users"></a> [developer\_users](#input\_developer\_users) | 開発者ユーザ | `list(string)` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | 環境名 | `string` | n/a | yes |
| <a name="input_user_account_id"></a> [user\_account\_id](#input\_user\_account\_id) | ユーザを作成するアカウントID | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sns_notification_topic_arn"></a> [sns\_notification\_topic\_arn](#output\_sns\_notification\_topic\_arn) | 出力 (オプション) |
| <a name="output_ssm_google_oauth_client_id"></a> [ssm\_google\_oauth\_client\_id](#output\_ssm\_google\_oauth\_client\_id) | n/a |
| <a name="output_ssm_google_oauth_client_secret"></a> [ssm\_google\_oauth\_client\_secret](#output\_ssm\_google\_oauth\_client\_secret) | n/a |
<!-- END_TF_DOCS -->