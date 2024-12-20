# tests/single.tftest.hcl

# Mock AWS Provider
mock_provider "aws" {}

# Test the single onboarding expecting it to fail
run "single_onboarding_variable_validation_test_fail" {
  command = plan
  variables {
    type                 = "single"
    aqua_random_id       = "1a2b3c4d5"
    aqua_group_name      = "aqua_group_name"
    aqua_autoconnect_url = ""
  }

  expect_failures = [
    var.region,
    var.regions,
    var.aqua_tenant_id,
    var.aqua_group_name,
    var.organizational_unit_id,
    var.aqua_random_id,
    var.aqua_bucket_name,
    var.aqua_autoconnect_url,
    var.aqua_worker_role_arn,
    var.aqua_session_id,
    var.aqua_api_key,
    var.aqua_api_secret,
    var.aqua_volscan_api_url,
    var.aqua_volscan_api_token,
    var.aqua_volscan_aws_account_id,
    var.aqua_cspm_url,
    var.aqua_cspm_aws_account_id,
    var.aqua_cspm_ipv4_address,
    var.aqua_cspm_role_prefix
  ]
}