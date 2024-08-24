variable "chart_version" {
  description = "Karpenter chart version"
  type        = string
}

variable "cluster_auth_token" {
  description = "EKS cluster auth token"
  type        = string
  default     = ""
}

variable "cluster_certificate_authority_data" {
  description = "Kubernetes cluster certificate authority data (module.eks.cluster_ca_certificate)"
  type        = string
}

variable "cluster_endpoint" {
  description = "Kubernetes cluster endpoint (module.eks.host)"
  type        = string
}

variable "cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default = {
    module = "eks-karpenter"
  }
}

