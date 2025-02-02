variable "acm_certificate_argo" {
  description = "ACM certificate arn for ARGO"
  type        = string
  default     = "arn:aws:acm:us-west-2:***:certificate/uuid"
}

variable "alb_enable_deletion_protection" {
  default = false
  type    = bool
}

variable "alb_sg_rules_argo" {
  type = list(any)
  default = [{
    type        = "ingress"
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "TCP"
    from_port   = "80"
    to_port     = "80"
    }, {
    type        = "ingress"
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "TCP"
    from_port   = "443"
    to_port     = "443"
    }, {
    type        = "egress"
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = "0"
    to_port     = "0"
  }]
}

variable "alb_tg_health_check_path" {
  description = "Path for health check for argo alb target group"
  type        = string
  default     = "/healthz"
}

variable "alb_tg_health_check_healthy_threshold" {
  description = "Number of consecutive health check successes required before considering a target healthy"
  type        = number
  default     = 2
}

variable "alb_tg_health_check_unhealthy_threshold" {
  description = "Number of consecutive health check failures required before considering a target unhealthy"
  type        = number
  default     = 3
}

variable "alb_tg_health_check_interval" {
  description = "Number of consecutive health check failures required before considering a target unhealthy"
  type        = number
  default     = 15
}

variable "alb_traffic_weight_to_eks_blue_argo" {
  type    = number
  default = 100
}

variable "create_dns_record_argo" {
  default = true
  type    = bool
}

variable "create_alb_for_argocd" {
  default = true
  type    = bool
}

variable "domain_name_argo" {
  description = "For alb listener. Domain of the certificate to look up. If no certificate is found with this name, an error will be returned"
  default     = "argocd.eks.us-west-2.dev.domain.com"
  type        = string
}

variable "eks_alb_idle_timeout" {
  type    = number
  default = 3600
}

variable "eks_clus" {
  description = "Cluster - blue or green"
  type        = string
  default     = "blue"
}

variable "eks_fname" {
  description = "Cluster name for project"
  type        = string
  default     = "eks-blue-us-west-2-dev"
}

variable "env" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "name_argo" {
  description = "Argo name"
  type        = string
  default     = "argocd"
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

variable "public_subnets" {
  description = "List of public subnet ids"
  type        = list(string)

}

variable "region" {
  description = "region name for project"
  type        = string
  default     = "us-west-2"
}

variable "route53_zone_name" {
  default = "domain.com"
  type    = string
}

variable "route53_zone_name_argo" {
  default = "domain.com"
  type    = string
}

variable "route53_zone_private" {
  default = false
  type    = bool
}

variable "route53_zone_private_argocd" {
  default = false
  type    = bool
}

variable "use_route53_zone" {
  default = true
  type    = bool
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default = {
    module = "eks-alb"
  }
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default = "vpc-0d92a29a969c4f59d"
}

