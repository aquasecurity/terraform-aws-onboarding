# modules/single/modules/stackset/variables.tf

variable "random_id" {
  description = "Random ID to apply to resource names"
  type        = string
}

variable "aws_account_id" {
  description = "AWS Account ID"
  type        = string
}

variable "aws_partition" {
  description = "AWS Partition"
  type        = string
}

variable "enabled_regions" {
  description = "Enabled AWS Regions to deploy Stack Sets on"
  type        = list(string)
}

variable "aqua_bucket_name" {
  description = "Aqua Bucket Name"
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

variable "event_bus_arn" {
  description = "Cloudwatch Event Bus ARN"
  type        = string
}

variable "create_vol_scan_resource" {
  description = "Create Volume Scanning Resource"
  type        = bool
  default     = true
}
