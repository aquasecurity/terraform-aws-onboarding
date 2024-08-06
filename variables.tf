# variables.tf

variable "type" {
  description = "The type of onboarding. Currently only 'single' onboarding types are supported"
  type        = string
  validation {
    condition     = var.type == "single"
    error_message = "Currently Only 'single' onboarding type are supported."
  }
}

variable "region" {
  description = "Main AWS Region to to deploy resources"
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

variable "aqua_volscan_api_url" {
  description = "Aqua Volume Scanning API URL"
  type        = string
  validation {
    condition     = can(regex("^https?://", var.aqua_volscan_api_url))
    error_message = "Aqua Volume Scanning API URL must start with or 'https://'"
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

variable "aqua_cspm_ipv4_address" {
  description = "Aqua CSPM IPv4 address"
  type        = string
  validation {
    condition     = can(cidrnetmask(var.aqua_cspm_ipv4_address))
    error_message = "Aqua CSPM IP address Must be a valid IPv4 CIDR block address."
  }
}

variable "aqua_volscan_api_token" {
  description = "Aqua Volume Scanning API Token"
  type        = string
  validation {
    condition     = length(var.aqua_volscan_api_token) > 0
    error_message = "Aqua Volume Scanning API Token must not be empty."
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

variable "aqua_autoconnect_url" {
  description = "Aqua Autoconnect API URL"
  type        = string
  validation {
    condition     = can(regex("^https?://", var.aqua_autoconnect_url))
    error_message = "Aqua Autoconnect API URL must start with or 'https://'"
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

variable "aqua_cspm_aws_account_id" {
  description = "Aqua CSPM AWS Account ID"
  type        = string
  validation {
    condition     = can(regex("^\\d{12}$", var.aqua_cspm_aws_account_id))
    error_message = "Aqua CSPM AWS account ID must be a 12-digit number."
  }
}

variable "aqua_worker_role_arn" {
  description = "Aqua Worker Role ARN"
  type        = string
  validation {
    condition     = length(var.aqua_worker_role_arn) > 0
    error_message = "Aqua Worker role ARN must not be empty."
  }
}

variable "aqua_session_id" {
  description = "Aqua Session ID"
  type        = string
}

variable "aqua_cspm_role_prefix" {
  description = "Aqua CSPM role name prefix"
  type        = string
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
