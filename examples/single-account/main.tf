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
  type                        = "single"
  region                      = "us-east-1"
  regions                     = ["eu-central-1", "ap-south-1"]
  additional_tags             = local.additional_tags
  aqua_api_key                = "<REPLACE_ME>"
  aqua_api_secret             = "<REPLACE_ME>"
  aqua_autoconnect_url        = "https://example-aqua-autoconnect-url.com"
  aqua_bucket_name            = "generic-bucket-name"
  aqua_volscan_aws_account_id = "123456789101"
  aqua_volscan_api_token      = "<REPLACE_ME>"
  aqua_volscan_api_url        = "https://example-aqua-volscan-api-url.com"
  aqua_cspm_group_id          = 123456
  aqua_cspm_aws_account_id    = "123456789101"
  aqua_cspm_ipv4_address      = "1.234.56.78/32"
  aqua_cspm_role_prefix       = ""
  aqua_cspm_url               = "https://example-aqua-cspm-api-url.com"
  aqua_worker_role_arn        = "arn:aws:iam::123456789101:role/role-arn"
  aqua_session_id             = "234e3cea-d84a-4b9e-bb36-92518e6a5772"
}

################################

# Output the onboarding status
output "onboarding_status" {
  value = module.aqua_aws_onboarding.onboarding_status
}
