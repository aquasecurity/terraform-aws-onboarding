# `stackset` module

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

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack_set.stack_set](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set) | resource |
| [aws_cloudformation_stack_set_instance.stack_set_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set_instance) | resource |
| [aws_iam_role.stackset_admin_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.stackset_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aqua_bucket_name"></a> [aqua\_bucket\_name](#input\_aqua\_bucket\_name) | Aqua Bucket Name | `string` | n/a | yes |
| <a name="input_aws_account_id"></a> [aws\_account\_id](#input\_aws\_account\_id) | AWS Account ID | `string` | n/a | yes |
| <a name="input_aws_partition"></a> [aws\_partition](#input\_aws\_partition) | AWS Partition | `string` | n/a | yes |
| <a name="input_create_vpcs"></a> [create\_vpcs](#input\_create\_vpcs) | Toggle to create VPCs | `bool` | n/a | yes |
| <a name="input_custom_internet_gateway_name"></a> [custom\_internet\_gateway\_name](#input\_custom\_internet\_gateway\_name) | Custom Internet Gateway Name | `string` | n/a | yes |
| <a name="input_custom_security_group_name"></a> [custom\_security\_group\_name](#input\_custom\_security\_group\_name) | Custom Security Group Name | `string` | n/a | yes |
| <a name="input_custom_vpc_name"></a> [custom\_vpc\_name](#input\_custom\_vpc\_name) | Custom VPC Name | `string` | n/a | yes |
| <a name="input_custom_vpc_subnet1_name"></a> [custom\_vpc\_subnet1\_name](#input\_custom\_vpc\_subnet1\_name) | Custom VPC Subnet 1 Name | `string` | n/a | yes |
| <a name="input_custom_vpc_subnet2_name"></a> [custom\_vpc\_subnet2\_name](#input\_custom\_vpc\_subnet2\_name) | Custom VPC Subnet 2 Name | `string` | n/a | yes |
| <a name="input_custom_vpc_subnet_route_table1_name"></a> [custom\_vpc\_subnet\_route\_table1\_name](#input\_custom\_vpc\_subnet\_route\_table1\_name) | Custom VPC Route Table 1 Name | `string` | n/a | yes |
| <a name="input_custom_vpc_subnet_route_table2_name"></a> [custom\_vpc\_subnet\_route\_table2\_name](#input\_custom\_vpc\_subnet\_route\_table2\_name) | Custom VPC Route Table 2 Name | `string` | n/a | yes |
| <a name="input_enabled_regions"></a> [enabled\_regions](#input\_enabled\_regions) | Enabled AWS Regions to deploy Stack Sets on | `list(string)` | n/a | yes |
| <a name="input_event_bus_arn"></a> [event\_bus\_arn](#input\_event\_bus\_arn) | Cloudwatch Event Bus ARN | `string` | n/a | yes |
| <a name="input_random_id"></a> [random\_id](#input\_random\_id) | Random ID to apply to resource names | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_stack_set_admin_role_arn"></a> [stack\_set\_admin\_role\_arn](#output\_stack\_set\_admin\_role\_arn) | ARN of the StackSet admin role |
| <a name="output_stack_set_admin_role_name"></a> [stack\_set\_admin\_role\_name](#output\_stack\_set\_admin\_role\_name) | Name of the StackSet admin role |
| <a name="output_stack_set_execution_role_arn"></a> [stack\_set\_execution\_role\_arn](#output\_stack\_set\_execution\_role\_arn) | ARN of the StackSet execution role |
| <a name="output_stack_set_execution_role_name"></a> [stack\_set\_execution\_role\_name](#output\_stack\_set\_execution\_role\_name) | Name of the StackSet execution role |
| <a name="output_stack_set_name"></a> [stack\_set\_name](#output\_stack\_set\_name) | Name of the CloudFormation StackSet |
| <a name="output_stack_set_template_url"></a> [stack\_set\_template\_url](#output\_stack\_set\_template\_url) | URL of the CloudFormation template used by the StackSet |
<!-- END_TF_DOCS -->