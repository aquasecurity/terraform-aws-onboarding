# modules/single/modules/trigger/variables.tf

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

variable "is_already_cspm_client" {
  description = "Boolean indicating if the client is already a CSPM client, to be sent to the Autoconnect API"
  type        = bool
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
