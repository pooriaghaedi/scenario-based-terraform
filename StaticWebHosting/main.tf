terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.55"
    }
  }
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