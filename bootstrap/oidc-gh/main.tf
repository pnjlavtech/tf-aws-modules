# First configure the OIDC provider in AWS account

# Third create the role based on the oidc policy template

# Fifth create a policy based on (gha) deploy policy doc (perms) template and sixth attach the policy to gha role 


#############################################

provider "aws" {
  region = var.aws_region
}

locals {
  environment = terraform.workspace
}

resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://${var.oidc_provider_url}"
  client_id_list  = var.oidc_client_id_list
  thumbprint_list = [data.tls_certificate.github_oidc.certificates[0].sha1_fingerprint]

  tags = {
    Company     = var.company
    Environment = local.environment
    Region      = var.region_code
    Purpose     = var.purpose
  }


}