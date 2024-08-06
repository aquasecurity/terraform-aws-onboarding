# tests/test.tfvars

# Global test variables

region                      = "us-west1"
regions                     = ["eu-central1", "us-east1", "us-west2"]
organizational_unit_id      = "o-1a2b3c4d5"
aqua_tenant_id              = "tenant_id"
aqua_bucket_name            = ""
aqua_worker_role_arn        = "aqua_worker_role_arn"
aqua_session_id             = ""
aqua_cspm_url               = "cspm-url.com"
aqua_cspm_role_prefix       = "role_prefix"
aqua_cspm_ipv4_address      = "127.0.0.1"
aqua_cspm_group_id          = 123456
aqua_cspm_aws_account_id    = "12345678901"
aqua_api_key                = "<REPLACE_ME>"
aqua_api_secret             = "<REPLACE_ME>"
aqua_volscan_api_url        = "volscan-api-url.com"
aqua_volscan_api_token      = "<REPLACE_ME>"
aqua_volscan_aws_account_id = "12345678901"
custom_cspm_role_name       = "+=custom_cspm_role_name"