# modules/single/modules/stackset/outputs.tf

output "stack_set_name" {
  description = "Name of the CloudFormation StackSet"
  value       = aws_cloudformation_stack_set.stack_set.name
}

output "stack_set_admin_role_arn" {
  description = "ARN of the StackSet admin role"
  value       = aws_iam_role.stackset_admin_role.arn
}

output "stack_set_admin_role_name" {
  description = "Name of the StackSet admin role"
  value       = aws_iam_role.stackset_admin_role.name
}

output "stack_set_execution_role_arn" {
  description = "ARN of the StackSet execution role"
  value       = aws_iam_role.stackset_execution_role.arn
}

output "stack_set_execution_role_name" {
  description = "Name of the StackSet execution role"
  value       = aws_iam_role.stackset_execution_role.name
}

output "stack_set_template_url" {
  description = "URL of the CloudFormation template used by the StackSet"
  value       = aws_cloudformation_stack_set.stack_set.template_url
}