
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
  # count    = var.create_in_non_prod_acct ? 1 : 0
  provider = "aws.${var.env}"
  name     = "${var.env}.${var.public_domain}"

  tags = {
    Company     = var.company
    Environment = var.env
    Region      = var.region_code
    Purpose     = "route53-zone-public"
  }

}


# Create "Delegating records" (in the management account by the env gha deploy role)
resource "aws_route53_record" "this" {
  # count = var.non_prod_create_in_mgmnt_acct ? 1 : 0
  provider = "aws.management"
  zone_id  = aws_route53_zone.root_zone.zone_id
  name     = "${var.env}"
  type     = "NS"
  ttl      = 300
  # records  = data.aws_route53_zone.non_prod_name_servers.name_servers
  records  = aws_route53_zone.this.name_servers

  tags = {
    Company     = var.company
    Environment = var.env
    Region      = var.region_code
    Purpose     = "route53-delegating-records"
  }
}
