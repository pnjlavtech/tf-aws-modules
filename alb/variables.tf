variable "acm_certificate_arn" {
  description = "ACM certificate arn"
  type        = string
  default     = "arn:aws:acm:us-west-2:***:certificate/uuid"
}

variable "alb_name" {
  description = "ALB name"
  type        = string
  default     = "alb-name"
}

variable "karpenter_node_group" {
  description = "Karpenter ASG name"
  type        = string
  default     = "karpenter-asg"
}

variable "public_domain" {
  description = "Public DNS zone name"
  type        = string
  default     = "domain.com"
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
}

variable "tags" {
  description = "Tags to be applied to resources"
  type        = map(string)

  default = {
    module = "alb"
  }
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC where resources will be deployed"
  type        = string
  default     = "10.230.0.0/16"
}

variable "vpc_id" {
  description = "VPC id where resources are  deployed"
  type        = string
  default     = ""
}