# modules/single/modules/kinesis/variables.tf

variable "random_id" {
  description = "Random ID to apply to resource names"
  type        = string
}

variable "aqua_volscan_api_url" {
  description = "Aqua Volume Scanning API URL"
  type        = string
}

variable "aqua_volscan_api_token" {
  description = "Aqua Volume Scanning API Token"
  type        = string
}

variable "custom_bucket_name" {
  description = "Custom bucket Name"
  type        = string
}

variable "custom_processor_lambda_role_name" {
  description = "Custom Processor lambda role Name"
  type        = string
}

variable "create_vol_scan_resource" {
  description = "Create Volume Scanning Resource"
  type        = bool
  default     = true
}
