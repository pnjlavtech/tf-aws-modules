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

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)

  default = {
    module = "eks-iam"
  }
}

