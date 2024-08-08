# modules/single/modules/trigger/versions.tf

terraform {
  required_version = ">= 1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.57.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3.3"
    }
  }
}