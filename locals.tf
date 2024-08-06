# locals.tf

locals {
  random_id = lower(random_string.id.result)
}