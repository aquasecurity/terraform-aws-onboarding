# modules/single/modules/lambda/outputs.tf

output "cspm_external_id" {
  description = "Aqua CSPM External ID generated by the 'generate_cspm_external_id_function' Lambda function"
  value       = local.cspm_external_id
}

output "volscan_external_id" {
  description = "Aqua Volume Scanning External ID generated by the 'generate_volscan_external_id_function' Lambda function"
  value       = local.volscan_external_id
}

output "is_already_cspm_client" {
  description = "Boolean indicating if the client is already a CSPM client, to be sent to the Autoconnect API"
  value       = local.is_already_cspm_client
}

output "cspm_lambda_execution_role_arn" {
  description = "The ARN of the lambda execution IAM role created for the CSPM"
  value       = aws_iam_role.cspm_lambda_execution_role.arn
}

output "cspm_role_arn" {
  description = "The ARN of the IAM role created for the CSPM"
  value       = aws_iam_role.cspm_role.arn
}

output "agentless_role_arn" {
  description = "The ARN of the IAM role created for the Agentless Volume Scanning"
  value       = aws_iam_role.agentless_role.arn
}
