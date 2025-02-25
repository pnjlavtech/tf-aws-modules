# variable "deploy_role_name" {
#   description = "Name of the IAM role for deployments"
#   type        = string
# }

variable "oidc_provider_url" {
  description = "GitHub url"
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}


variable "github_repository" {
  description = "GitHub repository in owner/repo format"
  type        = string
  default     = "pnjlavtech/*"  
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)

  default = {
    module = "iam-deploy"
  }
}


variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "company"     { default = "pnjlavtech" }
# variable "environment" { default = "prod" }
variable "region_code" { default = "usw2" }
variable "purpose"     { default = "iam-role-github-actions" }