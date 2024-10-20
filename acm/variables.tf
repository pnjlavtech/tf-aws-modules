variable "public_domain" {
  description = "Public DNS zone name"
  type        = string
  default     = "domain.com"
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default = {
    module = "acm"
  }
}

variable "wait_for_validation" {
  description = "Whether to wait for the validation to complete"
  type        = bool
  default     = false
}