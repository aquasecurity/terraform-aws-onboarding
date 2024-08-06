# modules/single/data.tf

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

# Fetch All AWS regions that are enabled
data "aws_regions" "enabled" {
  # Retrieve all AWS regions
  all_regions = true

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required", "opted-in"]
  }
}
