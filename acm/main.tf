 terraform {
  required_version = ">= 1.3.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.50"
    }
  }
}


locals {
  domain = var.public_domain

  # Removing trailing dot from domain - just to be sure :)
  domain_name = trimsuffix(local.domain, ".")

  zone_id = data.aws_route53_zone.this.zone_id
}


module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 5.1.1"

  domain_name = local.domain_name
  zone_id     = local.zone_id

  subject_alternative_names = [
    "*.${local.domain_name}",
  ]

  validation_method   = "DNS"
  wait_for_validation = false

  tags = var.tags

}