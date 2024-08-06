# locals.tf

locals {
  random_id = var.type == "single" ? lower(random_string.id[0].result) : null
}