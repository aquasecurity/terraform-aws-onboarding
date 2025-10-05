# modules/single/modules/trigger/variables.tf

variable "aws_account_id" {
  description = "AWS Account ID"
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

variable "aqua_autoconnect_url" {
  description = "Aqua Autoconnect API URL"
  type        = string
}

variable "aqua_cspm_url" {
  description = "Aqua CSPM API URL"
  type        = string
}

variable "aqua_session_id" {
  description = "Aqua Session ID"
  type        = string
}

variable "cspm_role_arn" {
  description = "CSPM Role ARN"
  type        = string
}

variable "cspm_external_id" {
  description = "Aqua CSPM External ID"
  type        = string
}

variable "volscan_role_arn" {
  description = "Volume Scanning Role ARN"
  type        = string
}

variable "volscan_external_id" {
  description = "Aqua Volume Scanning External ID"
  type        = string
}

variable "region" {
  description = "Main AWS Region to to deploy resources"
  type        = string
}

variable "additional_tags" {
  description = "Additional tags to be sent to the Autoconnect API"
  type        = map(string)
}

variable "create_vol_scan_resource" {
  description = "Create Volume Scanning Resource"
  type        = bool
  default     = true
}

variable "cspm_group_id" {
  description = "Aqua CSPM Group ID"
  type        = number
}

variable "custom_cspm_regions" {
  description = "Custom CSPM regions"
  type        = string
  default = ""
}

variable "base_cspm" {
  description = "Toggle for base CSPM only"
  type        = bool
  default     = false
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

variable "registry_scanning_role_arn" {
  description = "Registry Scanning Role ARN"
  type        = string
  default     = ""
}

variable "serverless_scanning_role_arn" {
  description = "Serverless Scanning Role ARN"
  type        = string
  default     = ""
}
