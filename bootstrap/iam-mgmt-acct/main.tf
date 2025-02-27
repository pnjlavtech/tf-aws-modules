
provider "aws" {
  region = var.aws_region
}


# Cross account roles in management account
resource "aws_iam_role" "management_role" {
  for_each = var.env_acct_map

  name = "${each.key}-cross-acct-management-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${each.value}:role/${each.key}-iam-role-github-actions-deploy"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = {
    Company     = var.company
    Environment = var.environment
    Region      = var.region_code
    Purpose     = var.purpose
    TFmodule    = "iam-mgmt-acct"
    Name        = "${each.key}-cross-acct-management-role"
  }

}

resource "aws_iam_policy" "management_policy" {
  for_each = var.env_acct_map

  name        = "${each.key}-management-policy"
  description = "Policy to allow specific actions in the management account for the ${each.key}-iam-role-github-actions-deploy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListHostedZonesByName",
          "route53:ListResourceRecordSets"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "management_policy_attachment" {
  for_each = var.env_acct_map

  role       = aws_iam_role.management_role[each.key].name
  policy_arn = aws_iam_policy.management_policy[each.key].arn
}