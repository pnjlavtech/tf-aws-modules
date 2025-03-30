variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "oidc_provider_url" {
  description = "GitHub url"
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "github_repository" {
  description = "GitHub repository in owner/repo format"
  type        = string
  default     = ""  
}

variable "management_account_id" {
  description = "AWS management account ID"
  type        = string
  default     = ""  
}


variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)

  default = {
    module = "iam-deploy"
  }
}


variable "company"     { default = "pnjlavtech" }
# variable "environment" set via terraform workspace which is how this module is deployed
variable "region_code" { default = "glob" }
variable "purpose"     { default = "iam-role-github-actions" }