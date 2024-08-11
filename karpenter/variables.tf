variable "cluster_certificate_authority_data" {
  description = "Kubernetes cluster certificate authority data (module.eks.cluster_ca_certificate)"
  type        = string
}

variable "cluster_endpoint" {
  description = "Kubernetes cluster endpoint (module.eks.host)"
  type        = string
}

# variable "cluster_name" {
#   description = "Kubernetes cluster name"
#   type        = string
# }

variable "eks_fname" {
  description = "Cluster name for project"
  type        = string
  default     = "dev-eks-a-us-west-2"
}

# variable "region" {
#   description = "region name for project"
#   type        = string
#   default     = "us-west-2"
# }

variable "tags" {
  description = "Tags"
  type        = map(string)
  default = {
    module = "eks-karpenter"
  }

}

