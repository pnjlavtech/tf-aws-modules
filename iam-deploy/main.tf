# First configure the OIDC provider in AWS account

# Third create the role based on the oidc policy template

provider "aws" {
  region = var.aws_region
}

locals {
  environment = terraform.workspace
}

resource "aws_iam_role" "github_actions_deploy_role" {
  # name = var.deploy_role_name
  name = "${local.environment}-iam-role-github-actions-deploy"

  assume_role_policy = data.aws_iam_policy_document.github_oidc_role_policy.json

  tags = {
    Company     = var.company
    Environment = local.environment
    Region      = var.region_code
    Purpose     = "iam-role-gha-deploy"
  }

}


resource "aws_iam_policy" "github_actions_deploy_policy" {
  name        = "${aws_iam_role.github_actions_deploy_role.name}-policy"
  description = "Policy for github actions deployment role"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowCommonDeploymentServices",
        Action = [ // Include only necessary permissions
          "ec2:*",
          "s3:*",
          "rds:*",
          "lambda:*",
          "cloudformation:*",
          "cloudwatch:*",
          "autoscaling:*",
          "elasticloadbalancing:*",
          "route53:*",
          "dynamodb:*",
          "eks:*",
          "ecs:*",
          "ecr:*",
          "ecr-public:*",
          "sns:*",
          "sqs:*",
          "elasticbeanstalk:*",
          "kinesis:*",
          "logs:*",
          "events:*",          
          "iam:*",
          "secretsmanager:*",
          "ssm:*",
          "kms:*",
          # "apigateway:*",
          "cloudfront:*",
          "acm:*",
          "cloudtrail:*",
          "config:*",
          "guardduty:*",
          "inspector:*",
          "waf:*",
          "shield:*",
          "waf-regional:*",
          "wafv2:*",
          "xray:*",
          "resource-groups:*",
          "resource-explorer:*",
          "servicecatalog:*",
          "servicequotas:*",
          "sts:*",
          ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Sid = "DenySensitiveActions",
        Action = [
          # "iam:*",
          "organizations:*",
          "account:*",
          # "sts:*",
          "signin:*",
          "support:*",
          "billing:*",
          "aws-portal:*",
          "budgets:*",
          "cur:*",
          "ce:*",],
        Effect   = "Deny",
        Resource = "*"
      }
    ]
  })

  tags = {
    Company     = var.company
    Environment = local.environment
    Region      = var.region_code
    Purpose     = "iam-role-gha-deploy-policy"
  }

}

resource "aws_iam_role_policy_attachment" "github_actions_deploy_policy_attachment" {
  role       = aws_iam_role.github_actions_deploy_role.name
  policy_arn = aws_iam_policy.github_actions_deploy_policy.arn
}

