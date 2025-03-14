variable "eks_clus" {
  description = "Cluster - blue or green"
  type        = string
  default     = "blue"
}

variable "eks_cluster_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.3.1"
}

variable "eks_fname" {
  description = "Cluster name for project"
  type        = string
  default     = "dev-usw2-eks-blue"
}

# "karpenter.sh/discovery" = var.eks_fname

variable "env" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "intra_subnets" {
  description = "List of intra subnet ids"
  type        = list(string)

}

variable "private_subnets" {
  description = "List of private subnet ids"
  type        = list(string)

}

variable "public_domain" {
  description = "Public DNS zone name"
  type        = string

  default = "domain.com"
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

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default = "vpc-0d92a29a969c4f59d"
}
     