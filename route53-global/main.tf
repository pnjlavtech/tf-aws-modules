terraform {
  required_version = ">= 1.8.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.50"
    }
  }
}



resource "aws_route53_zone" "this" {
  name     = "${var.region_code}.${var.env}.${var.domain_name}"
  tags = {
    Company     = var.company
    Environment = var.env
    Region      = var.region_code
    Purpose     = "route53-zone-public-env-region"
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
  # records  = data.aws_route53_zone.non_prod_name_servers.name_servers
  records  = aws_route53_zone.this.name_servers

}
