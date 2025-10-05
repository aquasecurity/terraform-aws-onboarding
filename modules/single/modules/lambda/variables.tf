# modules/single/modules/lambda/variables.tf

variable "random_id" {
  description = "Random ID to apply to resource names"
  type        = string
}

variable "aqua_api_key" {
  description = "Aqua API Key"
  type        = string
  sensitive   = true
}

variable "aqua_api_secret" {
  description = "Aqua API Secret"
  type        = string
  sensitive   = true
}

variable "aqua_volscan_aws_account_id" {
  description = "Aqua Volume Scanning AWS Account ID"
  type        = string
}

variable "aqua_autoconnect_url" {
  description = "Aqua Autoconnect API URL"
  type        = string
}

variable "aqua_cspm_url" {
  description = "Aqua CSPM API URL"
  type        = string
}

variable "aqua_cspm_aws_account_id" {
  description = "Aqua CSPM AWS Account ID"
  type        = string
}

variable "aqua_cspm_ipv4_address" {
  description = "Aqua CSPM IPv4 address"
  type        = string
}

variable "aqua_cspm_role_prefix" {
  description = "Aqua CSPM role name prefix"
  type        = string
}

variable "aqua_worker_role_arn" {
  description = "Aqua Worker Role ARN"
  type        = string
}

variable "custom_cspm_role_name" {
  description = "Custom CSPM role Name"
  type        = string
}

variable "custom_agentless_role_name" {
  description = "Custom Agentless role Name"
  type        = string
}

variable "create_vol_scan_resource" {
  description = "Create Volume Scanning Resource"
  type        = bool
  default     = true
}

variable "create_registry_scanning_resource" {
  description = "Create Registry Scanning Resource"
  type        = bool
  default     = true
}

variable "create_serverless_scanning_resource" {
  description = "Create Serverless Scanning Resource"
  type        = bool
  default     = true
}

variable "custom_registry_scanning_role_name" {
  description = "Custom Registry Scanning role Name"
  type        = string
  default     = ""
}

variable "custom_serverless_scanning_role_name" {
  description = "Custom Serverless Scanning role Name"
  type        = string
  default     = ""
}
