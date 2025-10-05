# modules/single/modules/trigger/trigger.tf

# Calling onboarding API
data "external" "aws_onboarding" {
  program = ["python3", "${path.module}/trigger-aws.py"]

  query = {
    autoconnect_url                 = var.aqua_autoconnect_url
    cspm_url                        = var.aqua_cspm_url
    aws_account_id                  = tostring(var.aws_account_id)
    api_key                         = sensitive(var.aqua_api_key)
    api_secret                      = sensitive(var.aqua_api_secret)
    cspm_role_arn                   = var.cspm_role_arn
    cspm_external_id                = var.cspm_external_id
    session_id                      = var.aqua_session_id
    volume_scanning_role_arn        = var.volscan_role_arn
    volume_scanning_external_id     = var.volscan_external_id
    region                          = var.region
    volume_scanning_deployment      = var.create_vol_scan_resource ? "true" : "false"
    registry_scanning_deployment    = !var.create_registry_scanning_resource ? "false" : "true"
    serverless_scanning_deployment  = !var.create_serverless_scanning_resource ? "false" : "true"
    registry_scan_role_arn          = var.registry_scanning_role_arn
    serverless_scan_role_arn        = var.serverless_scanning_role_arn
    cspm_group_id                   = var.cspm_group_id
    custom_cspm_regions             = var.custom_cspm_regions
    base_cspm                       = var.base_cspm
    additional_tags                 = join(",", [for key, value in var.additional_tags : "${key}:${value}"])
  }
}
