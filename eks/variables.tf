variable "domain_name" {
  description = "region-environment domain name"
  type        = string
  default     = ""
}

variable "eks_clus" {
  description = "Cluster - blue or green"
  type        = string
  default     = "blue"
}

variable "eks_cluster_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = ""
}

variable "eks_fname" {
  description = "Cluster name for project"
  type        = string
  default     = ""
}

variable "env" {
  description = "Environment"
  type        = string
  default     = ""
}

variable "intra_subnets" {
  description = "List of intra subnet ids"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnet ids"
  type        = list(string)
}

variable "region" {
  description = "region name"
  type        = string
  default     = ""
}

variable "region_code" {
  description = "region code Eg: usw2 "
  type        = string
  default     = ""
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
  default     = "vpc-0d92a29a969c4f59d"
}

variable "zone_id" {
  description = "AWS R53 zone id for the RegionCode.Environment.domainname"
  type        = string
  default     = "234432jkjlskjdsf"
}