variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = ""
}


variable "oidc_provider" {
  description = "EKS OIDC provider"
  type        = string
  default     = ""
}


variable "public_domain" {
  description = "Public DNS zone name"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)

  default = {
    module = "eks-iam"
  }
}

