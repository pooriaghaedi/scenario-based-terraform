module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  name   = local.name

  cidr                  = "172.24.0.0/16"
  secondary_cidr_blocks = ["172.25.0.0/16", "172.26.0.0/16"]

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["172.24.1.0/24", "172.24.2.0/24", "172.24.3.0/24"]
  public_subnets  = ["172.24.101.0/24", "172.24.102.0/24", "172.24.103.0/24"]

  enable_ipv6 = false

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
    Name                     = "public-${local.name}"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    # Tags subnets for Karpenter auto-discovery
    "karpenter.sh/discovery" = local.name
  }

  vpc_tags = {
    Name = local.name
  }
}
