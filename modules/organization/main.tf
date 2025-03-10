# modules/organization/main.tf

# Create Cloudformation stackset
resource "aws_cloudformation_stack_set" "stack_set" {
  name             = "autoconnect-organization-onboarding"
  description      = "Aqua Agentless StackSet"
  capabilities     = ["CAPABILITY_NAMED_IAM"]
  permission_model = "SERVICE_MANAGED"
  template_url     = "https://${var.aqua_bucket_name}.s3.amazonaws.com/onboarding_stackset_control_tower.yaml"
  auto_deployment {
    enabled                          = true
    retain_stacks_on_account_removal = false
  }
  parameters = {
    AquaApiKey                     = sensitive(var.aqua_api_key),
    AquaSecretKey                  = sensitive(var.aqua_api_secret),
    AquaGroupName                  = var.aqua_group_name,
    WorkerRoleArn                  = var.aqua_worker_role_arn,
    TenantId                       = var.aqua_tenant_id,
    AquaApiTokenVolScan            = sensitive(var.aqua_volscan_api_token),
    RandomID                       = var.aqua_random_id,
    ConfigurationID                = var.aqua_session_id,
    OrganizationID                 = var.organizational_unit_id,
    DeployedInfrastructureRegion   = var.region,
    AdditionalTags                 = join(",", [for key, value in var.additional_tags : "${key}:${value}"])
    CustomCSPMRoleName             = var.custom_cspm_role_name
    CustomAgentlessRoleName        = var.custom_agentless_role_name
    CustomBucketName               = var.custom_bucket_name
    CustomProcessorLambdaRoleName  = var.custom_processor_lambda_role_name
    CustomVpcName                  = var.custom_vpc_name
    CustomVpcSubnet1Name           = var.custom_vpc_subnet1_name
    CustomVpcSubnetRouteTable1Name = var.custom_vpc_subnet_route_table1_name
    CustomVpcSubnet2Name           = var.custom_vpc_subnet2_name
    CustomVpcSubnetRouteTable2Name = var.custom_vpc_subnet_route_table2_name
    CustomInternetGatewayName      = var.custom_internet_gateway_name
    CustomSecurityGroupName        = var.custom_security_group_name
  }
}

# Create Cloudformation stackset instance for each region specified
resource "aws_cloudformation_stack_set_instance" "stack_set_instance" {
  for_each       = toset(concat(var.regions, [var.region]))
  stack_set_name = aws_cloudformation_stack_set.stack_set.name
  region         = each.value
  deployment_targets {
    organizational_unit_ids = [var.organizational_unit_id]
  }
  operation_preferences {
    region_concurrency_type      = "PARALLEL"
    failure_tolerance_percentage = 100
    max_concurrent_percentage    = 100
  }
}

