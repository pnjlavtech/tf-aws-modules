variable "aws_region" {
  type    = string
  default = "us-west-2"
}

variable "company"     { default = "pnjlavtech" }
variable "environment" { default = "management" }
variable "region_code" { default = "glob" }
variable "purpose"     { default = "iam-role-cross-account" }


variable "env_acct_map" {
  description = "Mapping of environments to account IDs"
  type        = map(string)
  default     = {
    dev  = ""
    stg  = ""
    prod = ""
  }
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)
  default = {
    "Name" = "value"
  }
}
