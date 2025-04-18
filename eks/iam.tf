resource "aws_iam_policy" "eks_alb_iam_policy" {
  name = "${var.eks_fname}-alb-iam-policy"
  policy = jsonencode(
    {
      Statement = [
        {
          Action = [
            "iam:CreateServiceLinkedRole",
          ]
          Condition = {
            StringEquals = {
              "iam:AWSServiceName" = "elasticloadbalancing.amazonaws.com"
            }
          }
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "ec2:DescribeAccountAttributes",
            "ec2:DescribeAddresses",
            "ec2:DescribeAvailabilityZones",
            "ec2:DescribeInternetGateways",
            "ec2:DescribeVpcs",
            "ec2:DescribeVpcPeeringConnections",
            "ec2:DescribeSubnets",
            "ec2:DescribeSecurityGroups",
            "ec2:DescribeInstances",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DescribeTags",
            "ec2:GetCoipPoolUsage",
            "ec2:DescribeCoipPools",
            "elasticloadbalancing:DescribeLoadBalancers",
            "elasticloadbalancing:DescribeLoadBalancerAttributes",
            "elasticloadbalancing:DescribeListeners",
            "elasticloadbalancing:DescribeListenerCertificates",
            "elasticloadbalancing:DescribeSSLPolicies",
            "elasticloadbalancing:DescribeRules",
            "elasticloadbalancing:DescribeTargetGroups",
            "elasticloadbalancing:DescribeTargetGroupAttributes",
            "elasticloadbalancing:DescribeTargetHealth",
            "elasticloadbalancing:DescribeTags",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "cognito-idp:DescribeUserPoolClient",
            "acm:ListCertificates",
            "acm:DescribeCertificate",
            "iam:ListServerCertificates",
            "iam:GetServerCertificate",
            "waf-regional:GetWebACL",
            "waf-regional:GetWebACLForResource",
            "waf-regional:AssociateWebACL",
            "waf-regional:DisassociateWebACL",
            "wafv2:GetWebACL",
            "wafv2:GetWebACLForResource",
            "wafv2:AssociateWebACL",
            "wafv2:DisassociateWebACL",
            "shield:GetSubscriptionState",
            "shield:DescribeProtection",
            "shield:CreateProtection",
            "shield:DeleteProtection",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:RevokeSecurityGroupIngress",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "ec2:CreateSecurityGroup",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "ec2:CreateTags",
          ]
          Condition = {
            Null = {
              "aws:RequestTag/elbv2.k8s.aws/cluster" = "false"
            }
            StringEquals = {
              "ec2:CreateAction" = "CreateSecurityGroup"
            }
          }
          Effect   = "Allow"
          Resource = "arn:aws:ec2:*:*:security-group/*"
        },
        {
          Action = [
            "ec2:CreateTags",
            "ec2:DeleteTags",
          ]
          Condition = {
            Null = {
              "aws:RequestTag/elbv2.k8s.aws/cluster"  = "true"
              "aws:ResourceTag/elbv2.k8s.aws/cluster" = "false"
            }
          }
          Effect   = "Allow"
          Resource = "arn:aws:ec2:*:*:security-group/*"
        },
        {
          Action = [
            "ec2:AuthorizeSecurityGroupIngress",
            "ec2:RevokeSecurityGroupIngress",
            "ec2:DeleteSecurityGroup",
          ]
          Condition = {
            Null = {
              "aws:ResourceTag/elbv2.k8s.aws/cluster" = "false"
            }
          }
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "elasticloadbalancing:CreateLoadBalancer",
            "elasticloadbalancing:CreateTargetGroup",
          ]
          Condition = {
            Null = {
              "aws:RequestTag/elbv2.k8s.aws/cluster" = "false"
            }
          }
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "elasticloadbalancing:CreateListener",
            "elasticloadbalancing:DeleteListener",
            "elasticloadbalancing:CreateRule",
            "elasticloadbalancing:DeleteRule",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "elasticloadbalancing:AddTags",
            "elasticloadbalancing:RemoveTags",
          ]
          Condition = {
            Null = {
              "aws:RequestTag/elbv2.k8s.aws/cluster"  = "true"
              "aws:ResourceTag/elbv2.k8s.aws/cluster" = "false"
            }
          }
          Effect = "Allow"
          Resource = [
            "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
            "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
            "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*",
          ]
        },
        {
          Action = [
            "elasticloadbalancing:AddTags",
            "elasticloadbalancing:RemoveTags",
          ]
          Effect = "Allow"
          Resource = [
            "arn:aws:elasticloadbalancing:*:*:listener/net/*/*/*",
            "arn:aws:elasticloadbalancing:*:*:listener/app/*/*/*",
            "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*/*",
            "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*/*",
          ]
        },
        {
          Action = [
            "elasticloadbalancing:ModifyLoadBalancerAttributes",
            "elasticloadbalancing:SetIpAddressType",
            "elasticloadbalancing:SetSecurityGroups",
            "elasticloadbalancing:SetSubnets",
            "elasticloadbalancing:DeleteLoadBalancer",
            "elasticloadbalancing:ModifyTargetGroup",
            "elasticloadbalancing:ModifyTargetGroupAttributes",
            "elasticloadbalancing:DeleteTargetGroup",
          ]
          Condition = {
            Null = {
              "aws:ResourceTag/elbv2.k8s.aws/cluster" = "false"
            }
          }
          Effect   = "Allow"
          Resource = "*"
        },
        {
          Action = [
            "elasticloadbalancing:RegisterTargets",
            "elasticloadbalancing:DeregisterTargets",
          ]
          Effect   = "Allow"
          Resource = "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"
        },
        {
          Action = [
            "elasticloadbalancing:SetWebAcl",
            "elasticloadbalancing:ModifyListener",
            "elasticloadbalancing:AddListenerCertificates",
            "elasticloadbalancing:RemoveListenerCertificates",
            "elasticloadbalancing:ModifyRule",
          ]
          Effect   = "Allow"
          Resource = "*"
        },
      ]
      Version = "2012-10-17"
  })

}


resource "aws_iam_policy" "eks_external_dns_iam_policy" {
  name   = "${var.eks_fname}-external-dns-iam-policy"
  policy = data.aws_iam_policy_document.external_dns_iam_policy_document.json
}


resource "aws_iam_policy" "eks_external_secrets_iam_policy" {
  name   = "${var.eks_fname}-external-secrets-iam-policy"
  policy = jsonencode(
    {
      Statement = [
      {
        "Effect": "Allow",
        "Action": [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds",
          "ssm:GetParameter*",
        ],
        "Resource": [
          "arn:aws:secretsmanager:*:*:secret:*"
        ]
      }
      ]
      Version = "2012-10-17"
    }
  )
}



# Create the role aka service account
resource "aws_iam_role" "eks_alb_iam_role" {
  name = "${var.eks_fname}-alb-iam-role"

  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRoleWithWebIdentity"
          Condition = {
            StringEquals = {
              "${module.eks.oidc_provider}:aud" = "sts.amazonaws.com"
              "${module.eks.oidc_provider}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
            }
          }
          Effect = "Allow"
          Principal = {
            Federated = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:oidc-provider/${module.eks.oidc_provider}"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )

  tags = merge(var.tags, {
    "Name"          = "${var.eks_fname}-alb-iam-role"
    "Purpose"       = "eks-alb-deployment-irsa"
    "K8sKindName"   = "ServiceAccount--${var.eks_fname}-alb-iam-role"
    "DownstreamDep" = "helm-release--alb-ingress"
    "helm-release"  = "alb-ingress"
  })

}


# Create the role aka service account 
resource "aws_iam_role" "eks_external_dns_iam_role" {
  name = "${var.eks_fname}-external-dns-iam-role"

  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRoleWithWebIdentity"
          Condition = {
            StringEquals = {
              "${module.eks.oidc_provider}:aud" = "sts.amazonaws.com"
            }
          }
          Effect = "Allow"
          Principal = {
            Federated = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:oidc-provider/${module.eks.oidc_provider}"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )

  tags = merge(var.tags, {
    "Name"          = "${var.eks_fname}-external-dns-iam-role"
    "Purpose"       = "eks-external-dns-deployment-irsa"
    "K8sKindName"   = "ServiceAccount--${var.eks_fname}-external-dns-iam-role"
    "DownstreamDep" = "helm-release--external-dns"
    "helm-release"  = "external-dns"
  })

}


resource "aws_iam_role" "eks_external_secrets_iam_role" {
  name = "${var.eks_fname}-external-secrets-iam-role"

  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRoleWithWebIdentity"
          Condition = {
            StringEquals = {
              "${module.eks.oidc_provider}:aud" = "sts.amazonaws.com"
            }
          }
          Effect = "Allow"
          Principal = {
            Federated = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:oidc-provider/${module.eks.oidc_provider}"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )

  tags = merge(var.tags, {
    "Name"          = "${var.eks_fname}-external-secrets-iam-role"
    "Purpose"       = "eks-external-secrets-deployment-irsa"
    "K8sKindName"   = "ServiceAccount--${var.eks_fname}-external-secrets-iam-role"
    "DownstreamDep" = "helm-release--external-secrets"
    "helm-release"  = "external-secrets"
  })

}




resource "aws_iam_role_policy_attachment" "eks_alb_iam_role_policy_attachment" {
  policy_arn = aws_iam_policy.eks_alb_iam_policy.arn
  role       = aws_iam_role.eks_alb_iam_role.name
}


resource "aws_iam_role_policy_attachment" "eks_external_dns_iam_role_policy_attachment" {
  policy_arn = aws_iam_policy.eks_external_dns_iam_policy.arn
  role       = aws_iam_role.eks_external_dns_iam_role.name
}


resource "aws_iam_role_policy_attachment" "eks_external_secrets_iam_role_policy_attachment" {
  policy_arn = aws_iam_policy.eks_external_secrets_iam_policy.arn
  role       = aws_iam_role.eks_external_secrets_iam_role.name
}




resource "aws_ssm_parameter" "eks_alb_iam_role_parameter" {
  name        = "/${var.env}/${var.region_code}/eks/${var.eks_clus}/alb_iam_role"
  description = "Parameter that stores the eks_alb_iam_role name ARN"
  value       = aws_iam_role.eks_alb_iam_role.arn
  type        = "String"

  tags = merge(var.tags, {
    Name    = "/${var.env}/${var.region_code}/eks/${var.eks_clus}/alb_iam_role"
    Purpose = "eks-iam-ssm"
  })
}

resource "aws_ssm_parameter" "eks_external_dns_iam_role_parameter" {
  name        = "/${var.env}/${var.region_code}/eks/${var.eks_clus}/external_dns_iam_role"
  description = "Parameter that stores the eks_external_dns_iam_role ARN"
  value       = aws_iam_role.eks_external_dns_iam_role.arn
  type        = "String"

  tags = merge(var.tags, {
    Name    = "/${var.env}/${var.region_code}/eks/${var.eks_clus}/external_dns_iam_role"
    Purpose = "eks-iam-ssm"
  })
}

resource "aws_ssm_parameter" "eks_external_secrets_iam_role_parameter" {
  name        = "/${var.env}/${var.region_code}/eks/${var.eks_clus}/external_secrets_iam_role"
  description = "Parameter that stores the eks_external_secrets_iam_role ARN"
  value       = aws_iam_role.eks_external_secrets_iam_role.arn
  type        = "String"

  tags = merge(var.tags, {
    Name    = "/${var.env}/${var.region_code}/eks/${var.eks_clus}/external_secrets_iam_role"
    Purpose = "eks-iam-ssm"
  })
}
