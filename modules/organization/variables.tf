# modules/organization/variables.tf

variable "region" {
  description = "Main AWS Region to deploy resources"
  type        = string
}

variable "regions" {
  description = "AWS Regions to deploy discovery and scanning resources"
  type        = list(string)
}

variable "organizational_unit_id" {
  description = "AWS Organizational unit (OU) ID to deploy resources on"
  type        = string
}

variable "additional_tags" {
  description = "Additional tags to be sent to the Autoconnect API"
  type        = map(string)
  default     = {}
}

variable "aqua_tenant_id" {
  description = "Aqua Tenant ID"
  type        = string
}

variable "aqua_random_id" {
  description = "Aqua Random ID"
  type        = string
}

variable "aqua_worker_role_arn" {
  description = "Aqua Worker Role ARN"
  type        = string
}

variable "aqua_bucket_name" {
  description = "Aqua Bucket Name"
  type        = string
}

variable "aqua_api_key" {
  description = "Aqua API Key"
  type        = string
}

variable "aqua_api_secret" {
  description = "Aqua API Secret"
  type        = string
}

variable "aqua_volscan_api_token" {
  description = "Aqua Volume Scanning API Token"
  type        = string
}

variable "aqua_group_name" {
  description = "Aqua Group ID"
  type        = string
}

variable "aqua_session_id" {
  description = "Aqua Session ID"
  type        = string
}

variable "aqua_cspm_group_id" {
  description = "Aqua CSPM Group ID"
  type        = number
}

variable "custom_cspm_role_name" {
  description = "Custom CSPM role Name"
  type        = string
}

variable "custom_agentless_role_name" {
  description = "Custom Agentless role Name"
  type        = string
}

variable "custom_processor_lambda_role_name" {
  description = "Custom Processor lambda role Name"
  type        = string
}

variable "custom_bucket_name" {
  description = "Custom bucket Name"
  type        = string
}

variable "custom_vpc_name" {
  description = "Custom VPC Name"
  type        = string
}

variable "custom_vpc_subnet1_name" {
  description = "Custom VPC Subnet 1 Name"
  type        = string
}

variable "custom_vpc_subnet2_name" {
  description = "Custom VPC Subnet 2 Name"
  type        = string
}

variable "custom_vpc_subnet_route_table1_name" {
  description = "Custom VPC Route Table 1 Name"
  type        = string
}

variable "custom_vpc_subnet_route_table2_name" {
  description = "Custom VPC Route Table 2 Name"
  type        = string
}

variable "custom_internet_gateway_name" {
  description = "Custom Internet Gateway Name"
  type        = string
}

variable "custom_security_group_name" {
  description = "Custom Security Group Name"
  type        = string
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
