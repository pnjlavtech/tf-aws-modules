variable "oidc_client_id_list" {
  type    = list(string)
  default = ["sts.amazonaws.com"]
}

# variables.tf
variable "oidc_provider_url" {
  type    = string
  default = "token.actions.githubusercontent.com"
}

variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "company"     { default = "pnjlavtech" }
# variable "environment" { default = "prod" }
variable "region_code" { default = "usw2" }
variable "purpose"     { default = "oidcprovider" }