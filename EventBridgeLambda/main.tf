terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.55"
    }
  }
}

locals {
  function_name = "example"
  lambda_runtime = "go1.x"
  lambda_timeout = 6
  lambda_memory_size = 128
  lambda_reserved_concurrency = 100
}