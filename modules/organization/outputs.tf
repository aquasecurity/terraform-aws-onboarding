# modules/organization/outputs.tf

output "stack_set_name" {
  description = "Name of the CloudFormation StackSet"
  value       = try(aws_cloudformation_stack_set.stack_set.name, null)
}

output "stack_set_template_url" {
  description = "URL of the CloudFormation template used by the StackSet"
  value       = try(aws_cloudformation_stack_set.stack_set.template_url, null)
}
