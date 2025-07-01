# modules/single/modules/stackset/outputs.tf

output "stack_set_name" {
  description = "Name of the CloudFormation StackSet"
  value       = try(aws_cloudformation_stack_set.stack_set[0].name, "")
}

output "stack_set_admin_role_arn" {
  description = "ARN of the StackSet admin role"
  value       = try(aws_iam_role.stackset_admin_role[0].arn, "")
}

output "stack_set_admin_role_name" {
  description = "Name of the StackSet admin role"
  value       = try(aws_iam_role.stackset_admin_role[0].name, "")
}

output "stack_set_execution_role_arn" {
  description = "ARN of the StackSet execution role"
  value       = try(aws_iam_role.stackset_execution_role[0].arn, "")
}

output "stack_set_execution_role_name" {
  description = "Name of the StackSet execution role"
  value       = try(aws_iam_role.stackset_execution_role[0].name, "")
}

output "stack_set_template_url" {
  description = "URL of the CloudFormation template used by the StackSet"
  value       = try(aws_cloudformation_stack_set.stack_set[0].template_url, "")
}
