terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.55"
    }
  }
}
// Your Resources will be created in this Region. In this scenario S3 bucket.
# provider "aws" {
#   region = "ap-southeast-2"
# }

// ACM certificate must be created in us-east-1 in order to CloudFront can access it. 
provider "aws" {
  region = "us-east-1"
  alias = "useast1"
}

//Replace example with your own domain, TLD must be available on Route53
locals {
  name = "example"
  TLD = "example.com"
  subdomain = "web"
}

data "aws_route53_zone" "exampleTLD" {
  name         = local.TLD
}