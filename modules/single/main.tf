# modules/single/main.tf

module "kinesis" {
  source                            = "./modules/kinesis"
  random_id                         = var.random_id
  aqua_volscan_api_url              = var.aqua_volscan_api_url
  aqua_volscan_api_token            = var.aqua_volscan_api_token
  custom_bucket_name                = var.custom_bucket_name
  custom_processor_lambda_role_name = var.custom_processor_lambda_role_name
  create_vol_scan_resource    = var.volume_scanning_deployment == "true" ? true : false
}

module "lambda" {
  source                      = "./modules/lambda"
  random_id                   = var.random_id
  aqua_autoconnect_url        = var.aqua_autoconnect_url
  aqua_volscan_aws_account_id = var.aqua_volscan_aws_account_id
  aqua_api_key                = var.aqua_api_key
  aqua_api_secret             = var.aqua_api_secret
  aqua_cspm_ipv4_address      = var.aqua_cspm_ipv4_address
  aqua_cspm_aws_account_id    = var.aqua_cspm_aws_account_id
  aqua_cspm_url               = var.aqua_cspm_url
  aqua_worker_role_arn        = var.aqua_worker_role_arn
  aqua_cspm_role_prefix       = var.aqua_cspm_role_prefix
  custom_agentless_role_name  = var.custom_agentless_role_name
  custom_cspm_role_name       = var.custom_cspm_role_name
  create_vol_scan_resource    = var.volume_scanning_deployment == "true" ? true : false
  depends_on                  = [module.kinesis]
}

module "stackset" {
  source                              = "./modules/stackset"
  random_id                           = var.random_id
  aws_account_id                      = local.aws_account_id
  aws_partition                       = local.aws_partition
  aqua_bucket_name                    = var.aqua_bucket_name
  enabled_regions                     = local.enabled_regions
  create_vpcs                         = var.create_vpcs
  custom_vpc_name                     = var.custom_vpc_name
  custom_vpc_subnet_route_table1_name = var.custom_vpc_subnet_route_table1_name
  custom_vpc_subnet_route_table2_name = var.custom_vpc_subnet_route_table2_name
  custom_internet_gateway_name        = var.custom_internet_gateway_name
  custom_vpc_subnet1_name             = var.custom_vpc_subnet1_name
  custom_vpc_subnet2_name             = var.custom_vpc_subnet2_name
  custom_security_group_name          = var.custom_security_group_name
  event_bus_arn                       = module.kinesis.event_bus_arn
  create_vol_scan_resource            = var.volume_scanning_deployment == "true" ? true : false
  depends_on                          = [module.lambda]
}

module "trigger" {
  source                 = "./modules/trigger"
  region                 = var.region
  aqua_api_key           = var.aqua_api_key
  aqua_api_secret        = var.aqua_api_secret
  aqua_autoconnect_url   = var.aqua_autoconnect_url
  aqua_cspm_url          = var.aqua_cspm_url
  aws_account_id         = local.aws_account_id
  aqua_session_id        = var.aqua_session_id
  cspm_role_arn          = module.lambda.cspm_role_arn
  cspm_external_id       = module.lambda.cspm_external_id
  volscan_role_arn       = module.lambda.agentless_role_arn
  volscan_external_id    = module.lambda.volscan_external_id
  additional_tags        = var.additional_tags
  create_vol_scan_resource    = var.volume_scanning_deployment == "true" ? true : false
  cspm_group_id = var.aqua_cspm_group_id
  custom_cspm_regions = var.custom_cspm_regions
  base_cspm = var.base_cspm
  depends_on             = [module.stackset]
}
