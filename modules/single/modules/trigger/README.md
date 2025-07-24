# `trigger` module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.57.0 |
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.3.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | ~> 2.3.3 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [external_external.aws_onboarding](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional tags to be sent to the Autoconnect API | `map(string)` | n/a | yes |
| <a name="input_aqua_api_key"></a> [aqua\_api\_key](#input\_aqua\_api\_key) | Aqua API Key | `string` | n/a | yes |
| <a name="input_aqua_api_secret"></a> [aqua\_api\_secret](#input\_aqua\_api\_secret) | Aqua API Secret | `string` | n/a | yes |
| <a name="input_aqua_autoconnect_url"></a> [aqua\_autoconnect\_url](#input\_aqua\_autoconnect\_url) | Aqua Autoconnect API URL | `string` | n/a | yes |
| <a name="input_aqua_session_id"></a> [aqua\_session\_id](#input\_aqua\_session\_id) | Aqua Session ID | `string` | n/a | yes |
| <a name="input_cspm_external_id"></a> [cspm\_external\_id](#input\_cspm\_external\_id) | Aqua CSPM External ID | `string` | n/a | yes |
| <a name="input_cspm_role_arn"></a> [cspm\_role\_arn](#input\_cspm\_role\_arn) | CSPM Role ARN | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Main AWS Region to to deploy resources | `string` | n/a | yes |
| <a name="input_volscan_external_id"></a> [volscan\_external\_id](#input\_volscan\_external\_id) | Aqua Volume Scanning External ID | `string` | n/a | yes |
| <a name="input_volscan_role_arn"></a> [volscan\_role\_arn](#input\_volscan\_role\_arn) | Volume Scanning Role ARN | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_onboarding_status"></a> [onboarding\_status](#output\_onboarding\_status) | Onboarding API Status Result |
<!-- END_TF_DOCS -->
