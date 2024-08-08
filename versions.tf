# versions.tf

terraform {
  required_version = ">= 1.9.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.57.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6.2"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4.3"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3.3"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4.2"
    }
  }
}