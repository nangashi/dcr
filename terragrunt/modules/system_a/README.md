<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_monthly_aggregate"></a> [monthly\_aggregate](#module\_monthly\_aggregate) | terraform-aws-modules/lambda/aws | 6.5.0 |
| <a name="module_requirements_layer"></a> [requirements\_layer](#module\_requirements\_layer) | ../custom/layer | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.lambda_alarm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [archive_file.lambda](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_common_layer_arn"></a> [common\_layer\_arn](#input\_common\_layer\_arn) | 共通ライブラリのlayerのARN | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | 環境名 | `string` | n/a | yes |
| <a name="input_sns_notification_topic_arn"></a> [sns\_notification\_topic\_arn](#input\_sns\_notification\_topic\_arn) | 通知用SNSトピックのARN | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->