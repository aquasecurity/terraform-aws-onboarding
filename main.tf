# main.tf

resource "random_string" "id" {
  count   = var.type == "single" ? 1 : 0
  length  = 5
  special = false
}

module "single" {
  source                              = "./modules/single"
  count                               = var.type == "single" ? 1 : 0
  random_id                           = local.random_id
  region                              = var.region
  regions                             = var.regions
  additional_tags                     = var.additional_tags
  aqua_autoconnect_url                = var.aqua_autoconnect_url
  aqua_session_id                     = var.aqua_session_id
  aqua_worker_role_arn                = var.aqua_worker_role_arn
  aqua_api_key                        = var.aqua_api_key
  aqua_api_secret                     = var.aqua_api_secret
  aqua_bucket_name                    = var.aqua_bucket_name
  aqua_volscan_api_url                = var.aqua_volscan_api_url
  aqua_volscan_aws_account_id         = var.aqua_volscan_aws_account_id
  aqua_volscan_api_token              = var.aqua_volscan_api_token
  aqua_cspm_aws_account_id            = var.aqua_cspm_aws_account_id
  aqua_cspm_ipv4_address              = var.aqua_cspm_ipv4_address
  aqua_cspm_url                       = var.aqua_cspm_url
  aqua_cspm_group_id                  = var.aqua_cspm_group_id
  aqua_cspm_role_prefix               = var.aqua_cspm_role_prefix
  custom_cspm_role_name               = var.custom_cspm_role_name
  custom_bucket_name                  = var.custom_bucket_name
  custom_agentless_role_name          = var.custom_agentless_role_name
  custom_processor_lambda_role_name   = var.custom_processor_lambda_role_name
  create_vpcs                         = var.create_vpcs
  custom_internet_gateway_name        = var.custom_internet_gateway_name
  custom_security_group_name          = var.custom_security_group_name
  custom_vpc_name                     = var.custom_vpc_name
  custom_vpc_subnet1_name             = var.custom_vpc_subnet1_name
  custom_vpc_subnet2_name             = var.custom_vpc_subnet2_name
  custom_vpc_subnet_route_table1_name = var.custom_vpc_subnet_route_table1_name
  custom_vpc_subnet_route_table2_name = var.custom_vpc_subnet_route_table2_name
}

module "organization" {
  source                              = "./modules/organization"
  count                               = var.type == "organization" ? 1 : 0
  region                              = var.region
  regions                             = var.regions
  organizational_unit_id              = var.organizational_unit_id
  additional_tags                     = var.additional_tags
  aqua_tenant_id                      = var.aqua_tenant_id
  aqua_random_id                      = var.aqua_random_id
  aqua_worker_role_arn                = var.aqua_worker_role_arn
  aqua_bucket_name                    = var.aqua_bucket_name
  aqua_api_key                        = var.aqua_api_key
  aqua_api_secret                     = var.aqua_api_secret
  aqua_volscan_api_token              = var.aqua_volscan_api_token
  aqua_group_name                     = var.aqua_group_name
  aqua_session_id                     = var.aqua_session_id
  custom_cspm_role_name               = var.custom_cspm_role_name
  custom_bucket_name                  = var.custom_bucket_name
  custom_agentless_role_name          = var.custom_agentless_role_name
  custom_processor_lambda_role_name   = var.custom_processor_lambda_role_name
  custom_internet_gateway_name        = var.custom_internet_gateway_name
  custom_security_group_name          = var.custom_security_group_name
  custom_vpc_name                     = var.custom_vpc_name
  custom_vpc_subnet1_name             = var.custom_vpc_subnet1_name
  custom_vpc_subnet2_name             = var.custom_vpc_subnet2_name
  custom_vpc_subnet_route_table1_name = var.custom_vpc_subnet_route_table1_name
  custom_vpc_subnet_route_table2_name = var.custom_vpc_subnet_route_table2_name
}