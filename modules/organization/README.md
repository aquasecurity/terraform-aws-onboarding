# `organization` module

---

This Terraform module provisions the essential AWS infrastructure and configurations to deploy and integrate Aqua Security.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.57.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.57.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack_set.stack_set](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set) | resource |
| [aws_cloudformation_stack_set_instance.stack_set_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set_instance) | resource |

## Inputs

| Name                                                                                                                                                  | Description                                            | Type | Default | Required |
|-------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------|------|------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags)                                                                     | Additional tags to be sent to the Autoconnect API      | `map(string)` | `{}` |    no    |
| <a name="input_aqua_api_key"></a> [aqua\_api\_key](#input\_aqua\_api\_key)                                                                            | Aqua API Key                                           | `string` | n/a |   yes    |
| <a name="input_aqua_api_secret"></a> [aqua\_api\_secret](#input\_aqua\_api\_secret)                                                                   | Aqua API Secret                                        | `string` | n/a |   yes    |
| <a name="input_aqua_bucket_name"></a> [aqua\_bucket\_name](#input\_aqua\_bucket\_name)                                                                | Aqua Bucket Name                                       | `string` | n/a |   yes    |
| <a name="input_aqua_group_name"></a> [aqua\_group\_name](#input\_aqua\_group\_name)                                                                   | Aqua Group ID                                          | `string` | n/a |   yes    |
| <a name="input_aqua_random_id"></a> [aqua\_random\_id](#input\_aqua\_random\_id)                                                                      | Aqua Random ID                                         | `string` | n/a |   yes    |
| <a name="input_aqua_session_id"></a> [aqua\_session\_id](#input\_aqua\_session\_id)                                                                   | Aqua Session ID                                        | `string` | n/a |   yes    |
| <a name="input_aqua_tenant_id"></a> [aqua\_tenant\_id](#input\_aqua\_tenant\_id)                                                                      | Aqua Tenant ID                                         | `string` | n/a |   yes    |
| <a name="input_aqua_volscan_api_token"></a> [aqua\_volscan\_api\_token](#input\_aqua\_volscan\_api\_token)                                            | Aqua Volume Scanning API Token                         | `string` | n/a |   yes    |
| <a name="input_aqua_worker_role_arn"></a> [aqua\_worker\_role\_arn](#input\_aqua\_worker\_role\_arn)                                                  | Aqua Worker Role ARN                                   | `string` | n/a |   yes    |
| <a name="input_custom_agentless_role_name"></a> [custom\_agentless\_role\_name](#input\_custom\_agentless\_role\_name)                                | Custom Agentless role Name                             | `string` | n/a |   yes    |
| <a name="input_custom_bucket_name"></a> [custom\_bucket\_name](#input\_custom\_bucket\_name)                                                          | Custom bucket Name                                     | `string` | n/a |   yes    |
| <a name="input_custom_cspm_role_name"></a> [custom\_cspm\_role\_name](#input\_custom\_cspm\_role\_name)                                               | Custom CSPM role Name                                  | `string` | n/a |   yes    |
| <a name="input_custom_internet_gateway_name"></a> [custom\_internet\_gateway\_name](#input\_custom\_internet\_gateway\_name)                          | Custom Internet Gateway Name                           | `string` | n/a |   yes    |
| <a name="input_custom_processor_lambda_role_name"></a> [custom\_processor\_lambda\_role\_name](#input\_custom\_processor\_lambda\_role\_name)         | Custom Processor lambda role Name                      | `string` | n/a |   yes    |
| <a name="input_custom_security_group_name"></a> [custom\_security\_group\_name](#input\_custom\_security\_group\_name)                                | Custom Security Group Name                             | `string` | n/a |   yes    |
| <a name="input_custom_vpc_name"></a> [custom\_vpc\_name](#input\_custom\_vpc\_name)                                                                   | Custom VPC Name                                        | `string` | n/a |   yes    |
| <a name="input_custom_vpc_subnet1_name"></a> [custom\_vpc\_subnet1\_name](#input\_custom\_vpc\_subnet1\_name)                                         | Custom VPC Subnet 1 Name                               | `string` | n/a |   yes    |
| <a name="input_custom_vpc_subnet2_name"></a> [custom\_vpc\_subnet2\_name](#input\_custom\_vpc\_subnet2\_name)                                         | Custom VPC Subnet 2 Name                               | `string` | n/a |   yes    |
| <a name="input_custom_vpc_subnet_route_table1_name"></a> [custom\_vpc\_subnet\_route\_table1\_name](#input\_custom\_vpc\_subnet\_route\_table1\_name) | Custom VPC Route Table 1 Name                          | `string` | n/a |   yes    |
| <a name="input_custom_vpc_subnet_route_table2_name"></a> [custom\_vpc\_subnet\_route\_table2\_name](#input\_custom\_vpc\_subnet\_route\_table2\_name) | Custom VPC Route Table 2 Name                          | `string` | n/a |   yes    |
| <a name="input_custom_cspm_regions"></a> [custom\_cspm\_regions](#input\_custom\_cspm\_regions)                                                       | Custom Cspm Regions                                    | `string` | "" |    no    |
| <a name="input_organizational_unit_id"></a> [organizational\_unit\_id](#input\_organizational\_unit\_id)                                              | AWS Organizational unit (OU) ID to deploy resources on | `string` | n/a |   yes    |
| <a name="input_region"></a> [region](#input\_region)                                                                                                  | Main AWS Region to deploy resources                    | `string` | n/a |   yes    |
| <a name="input_regions"></a> [regions](#input\_regions)                                                                                               | AWS Regions to deploy discovery and scanning resources | `list(string)` | n/a |   yes    |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_stack_set_name"></a> [stack\_set\_name](#output\_stack\_set\_name) | Name of the CloudFormation StackSet |
| <a name="output_stack_set_template_url"></a> [stack\_set\_template\_url](#output\_stack\_set\_template\_url) | URL of the CloudFormation template used by the StackSet |
<!-- END_TF_DOCS -->
