# `kinesis` module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.4 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~> 2.4.2 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.57.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | ~> 2.4.2 |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.57.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_bus.event_bus](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_bus) | resource |
| [aws_cloudwatch_event_rule.event_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_log_group.kinesis_processor_lambda_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.kinesis_firehose_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.kinesis_stream_events_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.processor_lambda_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_kinesis_firehose_delivery_stream.kinesis_firehose](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_firehose_delivery_stream) | resource |
| [aws_kinesis_stream.kinesis_stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kinesis_stream) | resource |
| [aws_lambda_function.kinesis_processor_lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_s3_bucket.kinesis_firehose_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.kinesis_firehose_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_public_access_block.kinesis_firehose_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.kinesis_firehose_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [archive_file.kinesis_processor_function](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aqua_volscan_api_token"></a> [aqua\_volscan\_api\_token](#input\_aqua\_volscan\_api\_token) | Aqua Volume Scanning API Token | `string` | n/a | yes |
| <a name="input_aqua_volscan_api_url"></a> [aqua\_volscan\_api\_url](#input\_aqua\_volscan\_api\_url) | Aqua Volume Scanning API URL | `string` | n/a | yes |
| <a name="input_custom_bucket_name"></a> [custom\_bucket\_name](#input\_custom\_bucket\_name) | Custom bucket Name | `string` | n/a | yes |
| <a name="input_custom_processor_lambda_role_name"></a> [custom\_processor\_lambda\_role\_name](#input\_custom\_processor\_lambda\_role\_name) | Custom Processor lambda role Name | `string` | n/a | yes |
| <a name="input_random_id"></a> [random\_id](#input\_random\_id) | Random ID to apply to resource names | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_event_bus_arn"></a> [event\_bus\_arn](#output\_event\_bus\_arn) | Cloudwatch Event Bus ARN |
| <a name="output_event_rule_arn"></a> [event\_rule\_arn](#output\_event\_rule\_arn) | Cloudwatch Event Rule ARN |
| <a name="output_kinesis_firehose_bucket_name"></a> [kinesis\_firehose\_bucket\_name](#output\_kinesis\_firehose\_bucket\_name) | Kinesis Firehose S3 Bucket Name |
| <a name="output_kinesis_firehose_delivery_stream_arn"></a> [kinesis\_firehose\_delivery\_stream\_arn](#output\_kinesis\_firehose\_delivery\_stream\_arn) | Kinesis Firehose Delivery Stream ARN |
| <a name="output_kinesis_firehose_role_arn"></a> [kinesis\_firehose\_role\_arn](#output\_kinesis\_firehose\_role\_arn) | Kinesis Firehose Role ARN |
| <a name="output_kinesis_processor_lambda_execution_role_arn"></a> [kinesis\_processor\_lambda\_execution\_role\_arn](#output\_kinesis\_processor\_lambda\_execution\_role\_arn) | Kinesis Processor Lambda Execution Role ARN |
| <a name="output_kinesis_processor_lambda_function_arn"></a> [kinesis\_processor\_lambda\_function\_arn](#output\_kinesis\_processor\_lambda\_function\_arn) | Kinesis Processor Lambda Function ARN |
| <a name="output_kinesis_processor_lambda_log_group_name"></a> [kinesis\_processor\_lambda\_log\_group\_name](#output\_kinesis\_processor\_lambda\_log\_group\_name) | Kinesis Processor Lambda Cloudwatch Log Group Name |
| <a name="output_kinesis_stream_arn"></a> [kinesis\_stream\_arn](#output\_kinesis\_stream\_arn) | Kinesis Stream ARN |
| <a name="output_kinesis_stream_events_role_arn"></a> [kinesis\_stream\_events\_role\_arn](#output\_kinesis\_stream\_events\_role\_arn) | Kinesis Stream Events Role ARN |
<!-- END_TF_DOCS -->