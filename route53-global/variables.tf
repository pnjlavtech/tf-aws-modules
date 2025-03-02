# variable "create_in_mgmnt_acct" {
#   description = "Whether to create resources in the non-prod accounts"
#   type        = bool
#   default     = false
# }

variable "non_prod_create_in_mgmnt_acct" {
  description = "Whether to create resources in the management account"
  type        = bool
  default     = false
}

variable "create_in_non_prod_acct" {
  description = "Whether to create resources in the non-prod accounts"
  type        = bool
  default     = false
}

variable "env" {
  description = "AWS Account / Environment"
  type        = string
  default     = "dev"
}

variable "mgmt_acct_id" {
  description = "AWS Account ID for the management account"
  type        = string
  default     = ""
}

variable "non_prod_name_servers" {
  description = "Name servers for a given subdomain"
  type        = list(string)
  default     = ["ns1.domain.com", "ns2.domain.com"]
}

variable "public_domain" {
  description = "Public DNS zone name"
  type        = string
  default     = "domain.com"
}


variable "company"     { default = "pnjlavtech" }
# variable "environment" set via terraform workspace which is how this module is deployed
variable "region_code" { default = "glob" }
variable "purpose"     { default = "" }
