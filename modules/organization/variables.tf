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
  type = string
  default = "true"
}
