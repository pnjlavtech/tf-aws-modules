data "aws_caller_identity" "current" {}

data "aws_iam_openid_connect_provider" "github" {
  url = "${var.oidc_provider_url}"
}

data "aws_iam_policy_document" "github_oidc_role_policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringLike"
      values   = ["sts.amazonaws.com"]
      variable = "token.actions.githubusercontent.com:aud"
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:pnjlavtech/*"]
    }
  }
}





# Create the policy that will allow GitHub Actions to assume a certain role

# Second use the aws_iam_policy_document to create the template of the iam oidc policy. 

# Fourth identify the AWS services and policy actions needed for oidc (gha assumed) role to be able to perform


