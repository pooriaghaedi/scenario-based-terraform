terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.55"
    }
  }
}

locals {
  BastionPort = 2222
  BastionInstanceType = "t2.micro"
  BastionKeyName = "YOUR_KEY"
  BastionAMI = "ami-02f3f602d23f1659d"
  Bastionreserved_concurrency = 100
}