variable "name" {
  description = "Cluster name for project"
  type        = string
  default     = "eks"
}

variable "eks_cluster_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.30"
}

variable "region" {
  description = "region name for project"
  type        = string
  default     = "us-west-2"
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default = {
    module = "eks"
  }

}