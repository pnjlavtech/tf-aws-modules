data "aws_region" "this" {}

data "aws_caller_identity" "this" {}

data "aws_availability_zones" "available" {}

data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}


data "aws_route53_zone" "this" {
  # zone_id      = var.zone_id
  name         = var.domain_name 
  private_zone = false
}

data "aws_iam_policy_document" "external_dns_iam_policy_document" {
  statement {
    effect    = "Allow"
    actions   = ["route53:ChangeResourceRecordSets"]
    resources = [data.aws_route53_zone.this.arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets"
    ]
    resources = ["*"]
  }
}




