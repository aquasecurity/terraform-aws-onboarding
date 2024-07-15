# modules/single/locals.tf

locals {
  # Filter and select only the enabled regions that are specified in var.regions
  enabled_regions = [
    for region in data.aws_regions.enabled.names :
    region if contains(var.regions, region)
  ]

  # Fetch the current caller AWS account ID
  aws_account_id = data.aws_caller_identity.current.account_id

  # Fetch the current AWS partition
  aws_partition = data.aws_partition.current.partition
}