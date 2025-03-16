variable "company" {
  description = "Company name"
  type        = string
  default     = ""
}

variable "domain_name" {
  description = "Root domain name"
  type        = string
  default     = ""
}

variable "env" {
  description = "Environment eg dev, stg, prod"
  type        = string
  default     = ""
}

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

variable "purpose" {
  description = "Purpose of this module"
  type        = string
  default     = ""
}

variable "region_code" {
  description = "Region code, Eg usw2"
  type        = string
  default     = ""
}
