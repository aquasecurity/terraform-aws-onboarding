################################
# Define local variables
locals {
  additional_tags = { example = "true" }
}

# AWS Provider configuration
provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = merge(
      local.additional_tags,
      {
        aqua-agentless-scanner = "true"
      }
    )
  }
}

################################

# Create discovery and scanning resources
module "aqua_aws_onboarding" {
  source                      = "../../"
  type                        = "organization"
  region                      = "us-east-1"
  regions                     = ["eu-central-1", "ap-south-1"]
  additional_tags             = local.additional_tags
  organizational_unit_id      = "ou-1A23-bcd4fg5"
  aqua_api_key                = "<REPLACE_ME>"
  aqua_api_secret             = "<REPLACE_ME>"
  aqua_bucket_name            = "generic-bucket-name"
  aqua_volscan_aws_account_id = "123456789101"
  aqua_volscan_api_token      = "<REPLACE_ME>"
  aqua_volscan_api_url        = "https://example-aqua-volscan-api-url.com"
  aqua_cspm_group_id          = 123456
  aqua_cspm_aws_account_id    = "123456789101"
  aqua_cspm_ipv4_address      = "1.234.56.78/32"
  aqua_cspm_role_prefix       = ""
  aqua_tenant_id              = "17448"
  aqua_random_id              = "123a4bcd-e56f-7g8h-ik98-76543l2m1234"
  aqua_group_name             = "Default"
  aqua_cspm_url               = "https://example-aqua-cspm-api-url.com"
  aqua_worker_role_arn        = "arn:aws:iam::123456789101:role/role-arn"
  aqua_session_id             = "234e3cea-d84a-4b9e-bb36-92518e6a5772"
}
