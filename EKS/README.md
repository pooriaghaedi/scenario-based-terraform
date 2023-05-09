# EKS Cluster Deployment using Terraform

This repository contains the necessary terraform scripts to deploy a Kubernetes cluster on AWS using the Elastic Kubernetes Service (EKS). It also deploys the following components: 

1. Karpenet
2. External-DNS
3. External-Secrets
4. ALB Ingress Controller 

## Requirements

Before deploying the EKS cluster, the following are required: 

- A AWS IAM user with an access key and secret
- An S3 bucket to store terraform state
- A hosted zone configured in Route53
- A valid SSL certificate for the ingress controller

##