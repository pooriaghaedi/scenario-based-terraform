resource "helm_release" "external_secrets" {
    name             = "external-secrets"
    namespace        = "external-secrets"
    chart            = "external-secrets"
    repository       = "https://charts.external-secrets.io"
    create_namespace = true
  # version          = "1.4.6"

#   set {
# name  = "installCRDs"
# value = true
#   }
}

resource "aws_iam_role" "external_secret_sa" {
    name               = "external-secret-sa"
    assume_role_policy = <<POLICY
    {
        "Version"  : "2012-10-17",
        "Statement": [
            {
                "Effect"   : "Allow",
                "Principal": {
                    "Federated": "${module.eks.oidc_provider_arn}"
                },
                "Action"   : "sts:AssumeRoleWithWebIdentity",
                "Condition": {
                    "StringEquals": {
                        "${module.eks.oidc_provider}:aud": "sts.amazonaws.com",
                        "${module.eks.oidc_provider}:sub": "system:serviceaccount:${local.namespace}:external-secret"
                    }
                }
            }
        ]
    }
POLICY
}


resource "kubernetes_service_account_v1" "externalsecret" {
  metadata {
    name      = "external-secret"
    namespace = local.namespace
    labels    = {
      "app.kubernetes.io/name"      = "external-secret"
    # "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.external_secret_sa.arn
    }
  }
}

resource "aws_iam_role_policy" "externalsecret" {
    name        = "externalsecret"
  # description = "My test policy"
    role        = aws_iam_role.external_secret_sa.id
    policy      = <<EOT
{
    "Version"  : "2012-10-17",
    "Statement": [
        {
            "Sid"   : "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameter",
                "ssm:ListTagsForResource",
                "ssm:DescribeParameters"
            ],
            "Resource": "${var.secretarn}"
            
        }
    ]
}
EOT
}