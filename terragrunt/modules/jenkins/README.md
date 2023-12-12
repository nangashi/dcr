<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.jenkins_ecs_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecr_lifecycle_policy.jenkins_ecr_lifecycle_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.jenkins_ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecs_cluster.jenkins_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_service.jenkins_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.jenkins_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_efs_access_point.jenkins_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point) | resource |
| [aws_efs_file_system.jenkins_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_file_system_policy.jenkins_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system_policy) | resource |
| [aws_efs_mount_target.jenkins_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_iam_policy.jenkins_ecr_read_only_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.jenkins_ecs_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy.jenkins_efs_mount](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.jenkins_ecs_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.jenkins_task_execution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.jenkins_ecr_read_only_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.jenkins_ecs_log](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.jenkins_efs_mount](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lb_listener.jenkins_elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.jenkins_elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.jenkins_elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.jenkins_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.jenkins_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_iam_policy_document.jenkins_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_ssm_parameter.google_oauth_client_id](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |
| [aws_ssm_parameter.google_oauth_client_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ssm_parameter) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_current_tag"></a> [current\_tag](#input\_current\_tag) | n/a | `string` | n/a | yes |
| <a name="input_ecr_immutable"></a> [ecr\_immutable](#input\_ecr\_immutable) | jenkins parameter | `bool` | n/a | yes |
| <a name="input_elb_arn"></a> [elb\_arn](#input\_elb\_arn) | n/a | `string` | n/a | yes |
| <a name="input_elb_hostname"></a> [elb\_hostname](#input\_elb\_hostname) | n/a | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | 環境名 | `string` | n/a | yes |
| <a name="input_github_branch"></a> [github\_branch](#input\_github\_branch) | n/a | `string` | n/a | yes |
| <a name="input_github_repository_url"></a> [github\_repository\_url](#input\_github\_repository\_url) | n/a | `string` | n/a | yes |
| <a name="input_jenkins_theme_color"></a> [jenkins\_theme\_color](#input\_jenkins\_theme\_color) | n/a | `string` | n/a | yes |
| <a name="input_jenkins_url_prefix"></a> [jenkins\_url\_prefix](#input\_jenkins\_url\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_ssm_google_oauth_client_id"></a> [ssm\_google\_oauth\_client\_id](#input\_ssm\_google\_oauth\_client\_id) | from infrastructure | `string` | n/a | yes |
| <a name="input_ssm_google_oauth_client_secret"></a> [ssm\_google\_oauth\_client\_secret](#input\_ssm\_google\_oauth\_client\_secret) | n/a | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_system"></a> [system](#input\_system) | システム名 | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | from network | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_jenkins_url"></a> [jenkins\_url](#output\_jenkins\_url) | n/a |
<!-- END_TF_DOCS -->