# modules/single/modules/lambda/locals.tf

locals {
  # Decode the results of Lambda function invocations
  cspm_external_id       = jsondecode(aws_lambda_invocation.generate_cspm_external_id_function.result)["ExternalId"]
  volscan_external_id    = jsondecode(aws_lambda_invocation.generate_volscan_external_id_function.result)["ExternalId"]
  is_already_cspm_client = jsondecode(aws_lambda_invocation.create_cspm_key_function.result)["IsAlreadyCSPMClient"]
}
