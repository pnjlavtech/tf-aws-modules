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
}

# variable "chart_version" {
#   description = "Karpenter chart version"
#   type        = string
#   default     = "0.37.0"
# }


variable "tags" {
  description = "Tags"
  type        = map(string)
  default = {
    module = "eks-karpenter"
  }

}
