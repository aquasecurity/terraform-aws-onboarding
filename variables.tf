# variables.tf

variable "type" {
  description = "The type of onboarding. Valid values are 'single' or 'organization' onboarding types"
  type        = string
  validation {
    condition     = var.type == "single" || var.type == "organization"
    error_message = "Only 'single' or 'organization' onboarding types are supported"
  }
}

variable "region" {
  description = "Main AWS Region to deploy resources"
  type        = string
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "Invalid AWS region format. Please provide a valid AWS region in the format 'aa-region-code-1'."
  }
}

variable "regions" {
  description = "AWS Regions to deploy discovery and scanning resources"
  type        = list(string)
  validation {
    condition     = alltrue(flatten([for region in var.regions : can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", region))]))
    error_message = "Invalid AWS region format. Please provide a valid AWS region in the format 'aa-region-code-1'."
  }
}

variable "organizational_unit_id" {
  description = "AWS Organizational unit (OU) ID to deploy resources on (This should be provided only if type of onboarding is 'organization')"
  type        = string
  default     = ""
  validation {
    condition     = var.type == "organization" ? length(var.organizational_unit_id) > 0 : true
    error_message = "The Organizational unit (OU) ID must be provided when `type` is set to 'organization'."
  }
  validation {
    condition     = var.type == "organization" ? can(regex("^ou-[0-9a-z]{4,32}-[0-9a-z]{8,32}$|r-[0-9a-z]{4,32}$", var.organizational_unit_id)) : true
    error_message = "The Organizational unit (OU) ID must match the format 'ou-[0-9a-z]{4,32}-[0-9a-z]{8,32}' or 'r-[0-9a-z]{4,32}'"
  }
  validation {
    condition     = var.type == "single" ? length(var.organizational_unit_id) == 0 : true
    error_message = "The Organizational unit (OU) ID should be empty when type of onboarding is 'single'."
  }
}

variable "additional_tags" {
  description = "Additional tags to be sent to the Autoconnect API"
  type        = map(string)
  default     = {}
}

variable "show_outputs" {
  description = "Whether to show outputs after deployment"
  type        = bool
  default     = false
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.show_outputs))
    error_message = "Show outputs toggle must be either true or false."
  }
}

variable "aqua_tenant_id" {
  description = "Aqua Tenant ID (This should be provided only if type of onboarding is 'organization')"
  type        = string
  default     = ""
  validation {
    condition     = var.type == "organization" ? length(var.aqua_tenant_id) > 0 : true
    error_message = "Aqua Tenant ID must not be empty when type of onboarding is 'organization'."
  }
  validation {
    condition     = var.type == "organization" ? can(regex("^[0-9]+$", var.aqua_tenant_id)) : true
    error_message = "Aqua Tenant ID must contain only numeric characters."
  }
  validation {
    condition     = var.type == "single" ? length(var.aqua_tenant_id) == 0 : true
    error_message = "Aqua Tenant ID should be empty when type of onboarding is 'single'."
  }
}

variable "aqua_group_name" {
  description = "Aqua Group Name (This should be provided only if type of onboarding is 'organization')"
  type        = string
  default     = ""
  validation {
    condition     = var.type == "organization" ? length(var.aqua_group_name) > 0 : true
    error_message = "Aqua Group Name must not be empty when type of onboarding is 'organization'."
  }
  validation {
    condition     = var.type == "single" ? length(var.aqua_group_name) == 0 : true
    error_message = "Aqua Group Name should be empty when type of onboarding is 'single'."
  }
}

variable "aqua_random_id" {
  description = "Aqua Random ID (This should be provided only if type of onboarding is 'organization')"
  type        = string
  default     = ""
  validation {
    condition     = var.type == "organization" ? length(var.aqua_random_id) > 0 : true
    error_message = "Aqua Random ID must be provided when `type` is set to 'organization'."
  }
  validation {
    condition     = var.type == "single" ? length(var.aqua_random_id) == 0 : true
    error_message = "Aqua Tenant ID should be empty when type of onboarding is 'single'."
  }
}

variable "aqua_bucket_name" {
  description = "Aqua Bucket Name"
  type        = string
  validation {
    condition     = length(var.aqua_bucket_name) > 0
    error_message = "Aqua Bucket Name must not be empty."
  }
}

variable "aqua_autoconnect_url" {
  description = "Aqua Autoconnect API URL (This should be provided only if type of onboarding is 'single')"
  type        = string
  default     = ""
  validation {
    condition     = var.type == "single" ? can(regex("^https?://", var.aqua_autoconnect_url)) : true
    error_message = "Aqua Autoconnect API URL must start with or 'https://'."
  }
  validation {
    condition     = var.type == "single" ? length(var.aqua_autoconnect_url) > 0 : true
    error_message = "Aqua Autoconnect API URL must be provided when `type` is set to 'single'."
  }
  validation {
    condition     = var.type == "organization" ? length(var.aqua_autoconnect_url) == 0 : true
    error_message = "Aqua Autoconnect API URL should be empty when type of onboarding is 'organization'."
  }
}

variable "aqua_worker_role_arn" {
  description = "Aqua Worker Role ARN"
  type        = string
  validation {
    condition     = length(var.aqua_worker_role_arn) > 0
    error_message = "Aqua Worker role ARN must not be empty."
  }
  validation {
    condition     = can(regex("^arn:aws:iam::[[:digit:]]{12}:role/.+", var.aqua_worker_role_arn))
    error_message = "Aqua Worker role ARN must be a valid AWS IAM role ARN."
  }
}

variable "aqua_session_id" {
  description = "Aqua Session ID"
  type        = string
  validation {
    condition     = length(var.aqua_session_id) > 0
    error_message = "Aqua Session ID should not be empty."
  }
}

variable "aqua_api_key" {
  description = "Aqua API Key"
  type        = string
  validation {
    condition     = length(var.aqua_api_key) > 0
    error_message = "Aqua API key must not be empty."
  }
  validation {
    condition     = var.aqua_api_key != "<REPLACE_ME>"
    error_message = "Aqua API key must be replaced from its default value of <REPLACE_ME>."
  }
}

variable "aqua_api_secret" {
  description = "Aqua API Secret"
  type        = string
  validation {
    condition     = length(var.aqua_api_secret) > 0
    error_message = "Aqua API secret must not be empty."
  }
  validation {
    condition     = var.aqua_api_secret != "<REPLACE_ME>"
    error_message = "Aqua API secret must be replaced from its default value of <REPLACE_ME>."
  }
}

variable "aqua_volscan_api_url" {
  description = "Aqua Volume Scanning API URL"
  type        = string
  validation {
    condition     = can(regex("^https?://", var.aqua_volscan_api_url))
    error_message = "Aqua Volume Scanning API URL must start with or 'https://'"
  }
}

variable "aqua_volscan_api_token" {
  description = "Aqua Volume Scanning API Token"
  type        = string
  validation {
    condition     = length(var.aqua_volscan_api_token) > 0
    error_message = "Aqua Volume Scanning API Token must not be empty."
  }
  validation {
    condition     = var.aqua_volscan_api_token != "<REPLACE_ME>"
    error_message = "Aqua Volume Scanning API Token must be replaced from its default value of <REPLACE_ME>."
  }
}

variable "aqua_volscan_aws_account_id" {
  description = "Aqua Volume Scanning AWS Account ID"
  type        = string
  validation {
    condition     = can(regex("^\\d{12}$", var.aqua_volscan_aws_account_id))
    error_message = "Aqua Volume Scanning AWS account ID must be a 12-digit number."
  }
}

variable "aqua_cspm_ipv4_address" {
  description = "Aqua CSPM IPv4 address"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.aqua_cspm_ipv4_address))
    error_message = "Aqua CSPM IP address Must be a valid IPv4 CIDR block address."
  }
}

variable "aqua_cspm_url" {
  description = "Aqua CSPM API URL"
  type        = string
  validation {
    condition     = can(regex("^https?://", var.aqua_cspm_url))
    error_message = "Aqua CSPM API URL must start with or 'https://'"
  }
}

variable "aqua_cspm_group_id" {
  description = "Aqua CSPM Group ID"
  type        = number
  validation {
    condition     = var.aqua_cspm_group_id != null
    error_message = "Aqua CSPM Group ID must not be empty."
  }
}

variable "aqua_cspm_aws_account_id" {
  description = "Aqua CSPM AWS Account ID"
  type        = string
  validation {
    condition     = can(regex("^\\d{12}$", var.aqua_cspm_aws_account_id))
    error_message = "Aqua CSPM AWS account ID must be a 12-digit number."
  }
}

variable "aqua_cspm_role_prefix" {
  description = "Aqua CSPM role name prefix"
  type        = string
  validation {
    condition     = var.aqua_cspm_role_prefix == "uwbwh-" || var.aqua_cspm_role_prefix == "gtnpr-" || var.aqua_cspm_role_prefix == "jkebg-" || var.aqua_cspm_role_prefix == "hgwbs-" || var.aqua_cspm_role_prefix == ""
    error_message = "Aqua CSPM role name prefix must be one of: 'uwbwh-', 'gtnpr-', 'jkebg-', 'hgwbs-', or '' (empty string)."
  }
}

variable "custom_cspm_role_name" {
  description = "Custom CSPM role Name"
  type        = string
  default     = ""
  validation {
    condition     = length(var.custom_cspm_role_name) == 0 || (length(var.custom_cspm_role_name) >= 1 && length(var.custom_cspm_role_name) <= 64)
    error_message = "The CSPM IAM role name must be between 1 and 64 characters."
  }
  validation {
    condition     = length(var.custom_cspm_role_name) == 0 || can(regex("[a-zA-Z0-9+=,.@_-]+", var.custom_cspm_role_name))
    error_message = "The CSPM IAM role name can contain only alphanumeric characters and the following special characters: +=,.@_-"
  }
}

variable "custom_bucket_name" {
  description = "Custom bucket Name"
  type        = string
  default     = ""
  validation {
    condition     = length(var.custom_bucket_name) == 0 || (length(var.custom_bucket_name) >= 3 && length(var.custom_bucket_name) <= 63)
    error_message = "Custom Bucket Name must be between 3 (min) and 63 (max) characters long if provided."
  }
  validation {
    condition     = length(var.custom_bucket_name) == 0 || can(regex("^[a-z0-9.-]{1,64}$", var.custom_bucket_name))
    error_message = "Custom Bucket Name can consist only of lowercase letters, numbers, dots (.), and hyphens (-) if provided."
  }
  validation {
    condition     = length(var.custom_bucket_name) == 0 || can(regex("^[a-z0-9].*[a-z0-9]$", var.custom_bucket_name))
    error_message = "Custom Bucket name must begin and end with a letter or number if provided."
  }
  validation {
    condition     = length(var.custom_bucket_name) == 0 || !strcontains(var.custom_bucket_name, "..")
    error_message = "Custom Bucket Name must not contain two adjacent periods if provided."
  }
  validation {
    condition     = length(var.custom_bucket_name) == 0 || !can(regex("^[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}$", var.custom_bucket_name))
    error_message = "Custom Bucket Name must not be formatted as an IP address (for example, 192.168.5.4) if provided."
  }
  validation {
    condition     = length(var.custom_bucket_name) == 0 || !startswith(var.custom_bucket_name, "xn--")
    error_message = "Custom Bucket Name must not start with the prefix xn-- if provided."
  }
  validation {
    condition     = length(var.custom_bucket_name) == 0 || !startswith(var.custom_bucket_name, "sthree-")
    error_message = "Custom Bucket Name must not start with the prefix sthree- if provided."
  }
  validation {
    condition     = length(var.custom_bucket_name) == 0 || !endswith(var.custom_bucket_name, "-s3alias")
    error_message = "Custom Bucket Name must not end with the suffix -s3alias if provided."
  }
  validation {
    condition     = length(var.custom_bucket_name) == 0 || !endswith(var.custom_bucket_name, "--ol-s3")
    error_message = "Custom Bucket Name must not end with the suffix --ol-s3 if provided."
  }
}

variable "custom_agentless_role_name" {
  description = "Custom Agentless role Name"
  type        = string
  default     = ""
  validation {
    condition     = length(var.custom_agentless_role_name) == 0 || (length(var.custom_agentless_role_name) >= 1 && length(var.custom_agentless_role_name) <= 64)
    error_message = "The Agentless IAM role name must be between 1 and 64 characters."
  }
  validation {
    condition     = length(var.custom_agentless_role_name) == 0 || can(regex("[a-zA-Z0-9+=,.@_-]+", var.custom_agentless_role_name))
    error_message = "The Agentless IAM role name can contain only alphanumeric characters and the following special characters: +=,.@_-"
  }
}

variable "custom_processor_lambda_role_name" {
  description = "Custom Processor lambda role Name"
  type        = string
  default     = ""
  validation {
    condition     = length(var.custom_processor_lambda_role_name) == 0 || (length(var.custom_processor_lambda_role_name) >= 1 && length(var.custom_processor_lambda_role_name) <= 64)
    error_message = "The Processor Lambda IAM role name must be between 1 and 64 characters."
  }
  validation {
    condition     = length(var.custom_processor_lambda_role_name) == 0 || can(regex("[a-zA-Z0-9+=,.@_-]+", var.custom_processor_lambda_role_name))
    error_message = "The Processor Lambda IAM role name can contain only alphanumeric characters and the following special characters: +=,.@_-"
  }
}

variable "create_vpcs" {
  description = "Toggle to create VPCs"
  type        = bool
  default     = true
  validation {
    condition     = can(regex("^([t][r][u][e]|[f][a][l][s][e])$", var.create_vpcs))
    error_message = "Create vpcs must be either true or false."
  }
}

variable "custom_vpc_name" {
  description = "Custom VPC Name"
  type        = string
  default     = ""
}

variable "custom_vpc_subnet1_name" {
  description = "Custom VPC Subnet 1 Name"
  type        = string
  default     = ""
}

variable "custom_vpc_subnet2_name" {
  description = "Custom VPC Subnet 2 Name"
  type        = string
  default     = ""
}

variable "custom_vpc_subnet_route_table1_name" {
  description = "Custom VPC Route Table 1 Name"
  type        = string
  default     = ""
}

variable "custom_vpc_subnet_route_table2_name" {
  description = "Custom VPC Route Table 2 Name"
  type        = string
  default     = ""
}

variable "custom_internet_gateway_name" {
  description = "Custom Internet Gateway Name"
  type        = string
  default     = ""
}

variable "custom_security_group_name" {
  description = "Custom Security Group Name"
  type        = string
  default     = ""
}

variable "custom_cspm_regions" {
  description = "Custom CSPM regions"
  type        = string
  default     = ""
}

variable "volume_scanning_deployment" {
  description = "Toggle to deploy Volume Scanning resources"
  type        = string
  default     = "true"
  validation {
    condition     = var.volume_scanning_deployment == "true" || var.volume_scanning_deployment == "false"
    error_message = "Volume scanning deployment must be either 'true' or 'false'."
  }
}

variable "base_cspm" {
  description = "Toggle for base CSPM only"
  type        = bool
  default     = false
}

variable "registry_scanning_deployment" {
  description = "Toggle to deploy Registry/ECR scanning resources"
  type        = string
  default     = "true"
  validation {
    condition     = var.registry_scanning_deployment == "true" || var.registry_scanning_deployment == "false"
    error_message = "Registry scanning deployment must be either 'true' or 'false'."
  }
}

variable "serverless_scanning_deployment" {
  description = "Toggle to deploy Serverless/Lambda scanning resources"
  type        = string
  default     = "true"
  validation {
    condition     = var.serverless_scanning_deployment == "true" || var.serverless_scanning_deployment == "false"
    error_message = "Serverless scanning deployment must be either 'true' or 'false'."
  }
}

variable "custom_registry_scanning_role_name" {
  description = "Custom Registry Scanning role Name"
  type        = string
  default     = ""
  validation {
    condition     = length(var.custom_registry_scanning_role_name) == 0 || (length(var.custom_registry_scanning_role_name) >= 1 && length(var.custom_registry_scanning_role_name) <= 64)
    error_message = "The Registry Scanning IAM role name must be between 1 and 64 characters."
  }
  validation {
    condition     = length(var.custom_registry_scanning_role_name) == 0 || can(regex("[a-zA-Z0-9+=,.@_-]+", var.custom_registry_scanning_role_name))
    error_message = "The Registry Scanning IAM role name can contain only alphanumeric characters and the following special characters: +=,.@_-"
  }
}

variable "custom_serverless_scanning_role_name" {
  description = "Custom Serverless Scanning role Name"
  type        = string
  default     = ""
  validation {
    condition     = length(var.custom_serverless_scanning_role_name) == 0 || (length(var.custom_serverless_scanning_role_name) >= 1 && length(var.custom_serverless_scanning_role_name) <= 64)
    error_message = "The Serverless Scanning IAM role name must be between 1 and 64 characters."
  }
  validation {
    condition     = length(var.custom_serverless_scanning_role_name) == 0 || can(regex("[a-zA-Z0-9+=,.@_-]+", var.custom_serverless_scanning_role_name))
    error_message = "The Serverless Scanning IAM role name can contain only alphanumeric characters and the following special characters: +=,.@_-"
  }
}
