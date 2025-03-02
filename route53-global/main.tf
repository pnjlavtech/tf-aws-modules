terraform {
  required_version = ">= 1.8.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.50"
    }
  }
}


provider "aws" {
  region = "us-west-2"
}

provider "aws" {
  alias  = "management"
  region = "us-west-2"

  assume_role {
    role_arn = "arn:aws:iam::${var.mgmt_acct_id}:role/${var.env}-cross-acct-management-role"
    session_name = "${var.env}-assume-cross-acct-tf-session"
  }
}


resource "aws_route53_zone" "this" {
  name     = "${var.env}.${var.public_domain}"

  tags = {
    Company     = var.company
    Environment = var.env
    Region      = var.region_code
    Purpose     = "route53-zone-public"
  }
}


resource "aws_route53_zone" "root_zone" {
  name = "${var.public_domain}"
}


# Create "Delegating records" (in the management account by the env gha deploy role)
resource "aws_route53_record" "this" {
  provider = aws.management
  zone_id  = aws_route53_zone.root_zone.zone_id
  name     = "${var.env}"
  type     = "NS"
  ttl      = 300
  # records  = data.aws_route53_zone.non_prod_name_servers.name_servers
  records  = aws_route53_zone.this.name_servers

}
