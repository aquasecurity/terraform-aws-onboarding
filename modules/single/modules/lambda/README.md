# `lambda` module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.4.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.57.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | ~> 2.4.2 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.57.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.agentless_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.cspm_lambda_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.cspm_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.lambda_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_lambda_function.create_cspm_key_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.generate_cspm_external_id_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_function.generate_volscan_external_id_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_invocation.create_cspm_key_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [aws_lambda_invocation.generate_cspm_external_id_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [aws_lambda_invocation.generate_volscan_external_id_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_invocation) | resource |
| [time_sleep.sleep](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [archive_file.create_cspm_key_function](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [archive_file.generate_external_id_function](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aqua_api_key"></a> [aqua\_api\_key](#input\_aqua\_api\_key) | Aqua API Key | `string` | n/a | yes |
| <a name="input_aqua_api_secret"></a> [aqua\_api\_secret](#input\_aqua\_api\_secret) | Aqua API Secret | `string` | n/a | yes |
| <a name="input_aqua_autoconnect_url"></a> [aqua\_autoconnect\_url](#input\_aqua\_autoconnect\_url) | Aqua Autoconnect API URL | `string` | n/a | yes |
| <a name="input_aqua_cspm_aws_account_id"></a> [aqua\_cspm\_aws\_account\_id](#input\_aqua\_cspm\_aws\_account\_id) | Aqua CSPM AWS Account ID | `string` | n/a | yes |
| <a name="input_aqua_cspm_group_id"></a> [aqua\_cspm\_group\_id](#input\_aqua\_cspm\_group\_id) | Aqua CSPM Group ID | `number` | n/a | yes |
| <a name="input_aqua_cspm_ipv4_address"></a> [aqua\_cspm\_ipv4\_address](#input\_aqua\_cspm\_ipv4\_address) | Aqua CSPM IPv4 address | `string` | n/a | yes |
| <a name="input_aqua_cspm_role_prefix"></a> [aqua\_cspm\_role\_prefix](#input\_aqua\_cspm\_role\_prefix) | Aqua CSPM role name prefix | `string` | n/a | yes |
| <a name="input_aqua_cspm_url"></a> [aqua\_cspm\_url](#input\_aqua\_cspm\_url) | Aqua CSPM API URL | `string` | n/a | yes |
| <a name="input_aqua_volscan_aws_account_id"></a> [aqua\_volscan\_aws\_account\_id](#input\_aqua\_volscan\_aws\_account\_id) | Aqua Volume Scanning AWS Account ID | `string` | n/a | yes |
| <a name="input_aqua_worker_role_arn"></a> [aqua\_worker\_role\_arn](#input\_aqua\_worker\_role\_arn) | Aqua Worker Role ARN | `string` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS Account ID | `number` | n/a | yes |
| <a name="input_custom_agentless_role_name"></a> [custom\_agentless\_role\_name](#input\_custom\_agentless\_role\_name) | Custom Agentless role Name | `string` | n/a | yes |
| <a name="input_custom_cspm_role_name"></a> [custom\_cspm\_role\_name](#input\_custom\_cspm\_role\_name) | Custom CSPM role Name | `string` | n/a | yes |
| <a name="input_random_id"></a> [random\_id](#input\_random\_id) | Random ID to apply to resource names | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_agentless_role_arn"></a> [agentless\_role\_arn](#output\_agentless\_role\_arn) | The ARN of the IAM role created for the Agentless Volume Scanning |
| <a name="output_cspm_external_id"></a> [cspm\_external\_id](#output\_cspm\_external\_id) | Aqua CSPM External ID generated by the 'generate\_cspm\_external\_id\_function' Lambda function |
| <a name="output_cspm_lambda_execution_role_arn"></a> [cspm\_lambda\_execution\_role\_arn](#output\_cspm\_lambda\_execution\_role\_arn) | The ARN of the lambda execution IAM role created for the CSPM |
| <a name="output_cspm_role_arn"></a> [cspm\_role\_arn](#output\_cspm\_role\_arn) | The ARN of the IAM role created for the CSPM |
| <a name="output_volscan_external_id"></a> [volscan\_external\_id](#output\_volscan\_external\_id) | Aqua Volume Scanning External ID generated by the 'generate\_volscan\_external\_id\_function' Lambda function |
<!-- END_TF_DOCS -->
