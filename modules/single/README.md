# `single` module

---

This Terraform module provisions the essential AWS infrastructure and configurations to deploy and integrate Aqua Security.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.57.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.57.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kinesis"></a> [kinesis](#module\_kinesis) | ./modules/kinesis | n/a |
| <a name="module_lambda"></a> [lambda](#module\_lambda) | ./modules/lambda | n/a |
| <a name="module_stackset"></a> [stackset](#module\_stackset) | ./modules/stackset | n/a |
| <a name="module_trigger"></a> [trigger](#module\_trigger) | ./modules/trigger | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_regions.enabled](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/regions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tags"></a> [additional\_tags](#input\_additional\_tags) | Additional resource tags to will be send to the Autoconnect API | `map(string)` | n/a | yes |
| <a name="input_aqua_api_key"></a> [aqua\_api\_key](#input\_aqua\_api\_key) | Aqua API key | `string` | n/a | yes |
| <a name="input_aqua_api_secret"></a> [aqua\_api\_secret](#input\_aqua\_api\_secret) | Aqua API secret | `string` | n/a | yes |
| <a name="input_aqua_autoconnect_url"></a> [aqua\_autoconnect\_url](#input\_aqua\_autoconnect\_url) | Aqua Autoconnect API URL | `string` | n/a | yes |
| <a name="input_aqua_bucket_name"></a> [aqua\_bucket\_name](#input\_aqua\_bucket\_name) | Aqua Bucket Name | `string` | n/a | yes |
| <a name="input_aqua_cspm_aws_account_id"></a> [aqua\_cspm\_aws\_account\_id](#input\_aqua\_cspm\_aws\_account\_id) | Aqua CSPM AWS Account ID | `string` | n/a | yes |
| <a name="input_aqua_cspm_group_id"></a> [aqua\_cspm\_group\_id](#input\_aqua\_cspm\_group\_id) | Aqua CSPM Group ID | `number` | n/a | yes |
| <a name="input_aqua_cspm_ipv4_address"></a> [aqua\_cspm\_ipv4\_address](#input\_aqua\_cspm\_ipv4\_address) | Aqua CSPM IPv4 address | `string` | n/a | yes |
| <a name="input_aqua_cspm_role_prefix"></a> [aqua\_cspm\_role\_prefix](#input\_aqua\_cspm\_role\_prefix) | Aqua CSPM role name prefix | `string` | n/a | yes |
| <a name="input_aqua_cspm_url"></a> [aqua\_cspm\_url](#input\_aqua\_cspm\_url) | Aqua CSPM API URL | `string` | n/a | yes |
| <a name="input_aqua_session_id"></a> [aqua\_session\_id](#input\_aqua\_session\_id) | Aqua Session ID | `string` | n/a | yes |
| <a name="input_aqua_volscan_api_token"></a> [aqua\_volscan\_api\_token](#input\_aqua\_volscan\_api\_token) | Aqua Volume Scanning API Token | `string` | n/a | yes |
| <a name="input_aqua_volscan_api_url"></a> [aqua\_volscan\_api\_url](#input\_aqua\_volscan\_api\_url) | Aqua Volume Scanning API URL | `string` | n/a | yes |
| <a name="input_aqua_volscan_aws_account_id"></a> [aqua\_volscan\_aws\_account\_id](#input\_aqua\_volscan\_aws\_account\_id) | Aqua Volume Scanning AWS Account ID | `string` | n/a | yes |
| <a name="input_aqua_worker_role_arn"></a> [aqua\_worker\_role\_arn](#input\_aqua\_worker\_role\_arn) | Aqua Worker Role ARN | `string` | n/a | yes |
| <a name="input_create_vpcs"></a> [create\_vpcs](#input\_create\_vpcs) | Toggle to create VPCs | `bool` | n/a | yes |
| <a name="input_custom_agentless_role_name"></a> [custom\_agentless\_role\_name](#input\_custom\_agentless\_role\_name) | Custom Agentless role Name | `string` | n/a | yes |
| <a name="input_custom_bucket_name"></a> [custom\_bucket\_name](#input\_custom\_bucket\_name) | Custom bucket Name | `string` | n/a | yes |
| <a name="input_custom_cspm_role_name"></a> [custom\_cspm\_role\_name](#input\_custom\_cspm\_role\_name) | Custom CSPM role Name | `string` | n/a | yes |
| <a name="input_custom_internet_gateway_name"></a> [custom\_internet\_gateway\_name](#input\_custom\_internet\_gateway\_name) | Custom Internet Gateway Name | `string` | n/a | yes |
| <a name="input_custom_processor_lambda_role_name"></a> [custom\_processor\_lambda\_role\_name](#input\_custom\_processor\_lambda\_role\_name) | Custom Processor lambda role Name | `string` | n/a | yes |
| <a name="input_custom_security_group_name"></a> [custom\_security\_group\_name](#input\_custom\_security\_group\_name) | Custom Security Group Name | `string` | n/a | yes |
| <a name="input_custom_vpc_name"></a> [custom\_vpc\_name](#input\_custom\_vpc\_name) | Custom VPC Name | `string` | n/a | yes |
| <a name="input_custom_vpc_subnet1_name"></a> [custom\_vpc\_subnet1\_name](#input\_custom\_vpc\_subnet1\_name) | Custom VPC Subnet 1 Name | `string` | n/a | yes |
| <a name="input_custom_vpc_subnet2_name"></a> [custom\_vpc\_subnet2\_name](#input\_custom\_vpc\_subnet2\_name) | Custom VPC Subnet 2 Name | `string` | n/a | yes |
| <a name="input_custom_vpc_subnet_route_table1_name"></a> [custom\_vpc\_subnet\_route\_table1\_name](#input\_custom\_vpc\_subnet\_route\_table1\_name) | Custom VPC Route Table 1 Name | `string` | n/a | yes |
| <a name="input_custom_vpc_subnet_route_table2_name"></a> [custom\_vpc\_subnet\_route\_table2\_name](#input\_custom\_vpc\_subnet\_route\_table2\_name) | Custom VPC Route Table 2 Name | `string` | n/a | yes |
| <a name="input_random_id"></a> [random\_id](#input\_random\_id) | Random ID to apply to resource names | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Main AWS Region to to deploy resources | `string` | n/a | yes |
| <a name="input_regions"></a> [regions](#input\_regions) | AWS Regions to deploy discovery and scanning resources | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_agentless_role_arn"></a> [agentless\_role\_arn](#output\_agentless\_role\_arn) | The ARN of the IAM role created for the Agentless Volume Scanning |
| <a name="output_cloudwatch_event_bus_arn"></a> [cloudwatch\_event\_bus\_arn](#output\_cloudwatch\_event\_bus\_arn) | Cloudwatch Event Bus ARN |
| <a name="output_cloudwatch_event_rule_arn"></a> [cloudwatch\_event\_rule\_arn](#output\_cloudwatch\_event\_rule\_arn) | Cloudwatch Event Rule ARN |
| <a name="output_cspm_external_id"></a> [cspm\_external\_id](#output\_cspm\_external\_id) | Aqua CSPM External ID generated by the 'generate\_cspm\_external\_id\_function' Lambda function |
| <a name="output_cspm_lambda_execution_role_arn"></a> [cspm\_lambda\_execution\_role\_arn](#output\_cspm\_lambda\_execution\_role\_arn) | The ARN of the lambda execution IAM role created for the CSPM |
| <a name="output_cspm_role_arn"></a> [cspm\_role\_arn](#output\_cspm\_role\_arn) | The ARN of the IAM role created for the CSPM |
| <a name="output_is_already_cspm_client"></a> [is\_already\_cspm\_client](#output\_is\_already\_cspm\_client) | Boolean indicating if the client is already a CSPM client, to be sent to the Autoconnect API |
| <a name="output_kinesis_firehose_bucket_name"></a> [kinesis\_firehose\_bucket\_name](#output\_kinesis\_firehose\_bucket\_name) | Kinesis Firehose S3 Bucket Name |
| <a name="output_kinesis_firehose_delivery_stream_arn"></a> [kinesis\_firehose\_delivery\_stream\_arn](#output\_kinesis\_firehose\_delivery\_stream\_arn) | Kinesis Firehose Delivery Stream ARN |
| <a name="output_kinesis_firehose_role_arn"></a> [kinesis\_firehose\_role\_arn](#output\_kinesis\_firehose\_role\_arn) | Kinesis Firehose Role ARN |
| <a name="output_kinesis_processor_lambda_execution_role_arn"></a> [kinesis\_processor\_lambda\_execution\_role\_arn](#output\_kinesis\_processor\_lambda\_execution\_role\_arn) | Kinesis Processor Lambda Execution Role ARN |
| <a name="output_kinesis_processor_lambda_function_arn"></a> [kinesis\_processor\_lambda\_function\_arn](#output\_kinesis\_processor\_lambda\_function\_arn) | Kinesis Processor Lambda Function ARN |
| <a name="output_kinesis_processor_lambda_log_group_name"></a> [kinesis\_processor\_lambda\_log\_group\_name](#output\_kinesis\_processor\_lambda\_log\_group\_name) | Kinesis Processor Lambda Cloudwatch Log Group Name |
| <a name="output_kinesis_stream_arn"></a> [kinesis\_stream\_arn](#output\_kinesis\_stream\_arn) | Kinesis Stream ARN |
| <a name="output_kinesis_stream_events_role_arn"></a> [kinesis\_stream\_events\_role\_arn](#output\_kinesis\_stream\_events\_role\_arn) | Kinesis Stream Events Role ARN |
| <a name="output_onboarding_status"></a> [onboarding\_status](#output\_onboarding\_status) | Onboarding API Status Result |
| <a name="output_stack_set_admin_role_arn"></a> [stack\_set\_admin\_role\_arn](#output\_stack\_set\_admin\_role\_arn) | ARN of the StackSet admin role |
| <a name="output_stack_set_admin_role_name"></a> [stack\_set\_admin\_role\_name](#output\_stack\_set\_admin\_role\_name) | Name of the StackSet admin role |
| <a name="output_stack_set_execution_role_arn"></a> [stack\_set\_execution\_role\_arn](#output\_stack\_set\_execution\_role\_arn) | ARN of the StackSet execution role |
| <a name="output_stack_set_execution_role_name"></a> [stack\_set\_execution\_role\_name](#output\_stack\_set\_execution\_role\_name) | Name of the StackSet execution role |
| <a name="output_stack_set_name"></a> [stack\_set\_name](#output\_stack\_set\_name) | Name of the CloudFormation StackSet |
| <a name="output_stack_set_template_url"></a> [stack\_set\_template\_url](#output\_stack\_set\_template\_url) | URL of the CloudFormation template used by the StackSet |
| <a name="output_volscan_external_id"></a> [volscan\_external\_id](#output\_volscan\_external\_id) | Aqua Volume Scanning External ID generated by the 'generate\_volscan\_external\_id\_function' Lambda function |
<!-- END_TF_DOCS -->