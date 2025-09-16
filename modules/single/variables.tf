# modules/single/variables.tf

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

variable "aqua_volscan_aws_account_id" {
  description = "Aqua Volume Scanning AWS Account ID"
  type        = string
}

variable "aqua_api_key" {
  description = "Aqua API key"
  type        = string
}

variable "aqua_api_secret" {
  description = "Aqua API secret"
  type        = string
}

variable "aqua_bucket_name" {
  description = "Aqua Bucket Name"
  type        = string
}

variable "aqua_cspm_aws_account_id" {
  description = "Aqua CSPM AWS Account ID"
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

variable "aqua_cspm_group_id" {
  description = "Aqua CSPM Group ID"
  type        = number
}

variable "aqua_cspm_ipv4_address" {
  description = "Aqua CSPM IPv4 address"
  type        = string
}

variable "aqua_worker_role_arn" {
  description = "Aqua Worker Role ARN"
  type        = string
}

variable "aqua_session_id" {
  description = "Aqua Session ID"
  type        = string
}

variable "aqua_cspm_role_prefix" {
  description = "Aqua CSPM role name prefix"
  type        = string
}

variable "regions" {
  description = "AWS Regions to deploy discovery and scanning resources"
  type        = list(string)
}

variable "region" {
  description = "Main AWS Region to to deploy resources"
  type        = string
}

variable "custom_cspm_role_name" {
  description = "Custom CSPM role Name"
  type        = string
}

variable "custom_bucket_name" {
  description = "Custom bucket Name"
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

variable "create_vpcs" {
  description = "Toggle to create VPCs"
  type        = bool
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

variable "additional_tags" {
  description = "Additional resource tags to will be send to the Autoconnect API"
  type        = map(string)
}

variable "custom_cspm_regions" {
  description = "Custom CSPM regions"
  type        = string
  default     = ""
}

variable "volume_scanning_deployment" {
  description = "Toggle to deploy volume scanning resources"
  type        = string
  default     = "true"
}

variable "base_cspm" {
  description = "Toggle for base CSPM only"
  type        = bool
  default     = false
}
