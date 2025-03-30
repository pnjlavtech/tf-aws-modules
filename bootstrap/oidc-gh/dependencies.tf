# Create the policy that will allow GitHub Actions to assume a certain role

# Second use the aws_iam_policy_document to create the template of the iam oidc policy. 

# Fourth identify the AWS services and policy actions needed for oidc (gha assumed) role to be able to perform

data "tls_certificate" "github_oidc" {
  url = "https://${var.oidc_provider_url}"
}

