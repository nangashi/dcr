<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_external"></a> [external](#provider\_external) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_lambda_source"></a> [lambda\_source](#module\_lambda\_source) | terraform-aws-modules/s3-bucket/aws | ~> 3.0 |
| <a name="module_monthly_aggregate"></a> [monthly\_aggregate](#module\_monthly\_aggregate) | terraform-aws-modules/lambda/aws | ~> 6.0 |

## Resources

| Name | Type |
|------|------|
| [aws_lambda_layer_version.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_layer_version) | resource |
| [archive_file.lambda_layer](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [external_external.lambda_layer](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | 環境名 | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->