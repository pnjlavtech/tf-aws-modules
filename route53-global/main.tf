terraform {
  required_version = ">= 1.8.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.50"
    }
  }
}

module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 3.0"

  zones = {
    "${var.region_code}.${var.env}.${var.domain_name}" = {
      comment = "${var.region_code}.${var.env}.${var.domain_name}"
      tags = {
        Company     = var.company
        Environment = var.env
        Region      = var.region_code
        Purpose     = "route53-zone-public-env-region"
      }    
    }

    "${var.region_code}-int.${var.env}.${var.domain_name}" = {
      comment = "${var.region_code}-int.${var.env}.${var.domain_name}"
      tags = {
        Company     = var.company
        Environment = var.env
        Region      = var.region_code
        Purpose     = "route53-zone-private-internal-env-region"
      }    
    }
  }

}


data "aws_route53_zone" "root_zone" {
  provider = aws.management
  name     = "${var.domain_name}"
}


# Create "Delegating records" (in the management account by the env gha deploy role)
resource "aws_route53_record" "this" {
  provider = aws.management
  zone_id  = data.aws_route53_zone.root_zone.zone_id
  name     = "${var.env}"
  type     = "NS"
  ttl      = 300

  records = module.zones.route53_zone_name_servers["${var.region_code}.${var.env}.${var.domain_name}"]
  depends_on = [module.zones]

}
