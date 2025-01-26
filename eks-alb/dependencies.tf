data "aws_acm_certificate" "acm_certificate_argo" {
  count  = var.create_alb_for_argocd ? 1 : 0
  domain = var.domain_name_argo
}


data "aws_route53_zone" "route53_zone" {
  count = var.use_route53_zone ? 1 : 0
  name  = var.route53_zone_name

  private_zone = var.route53_zone_private
}

data "aws_route53_zone" "route53_zone_argocd" {
  count = var.use_route53_zone ? 1 : 0
  name  = var.route53_zone_name_argo

  private_zone = var.route53_zone_private_argocd
}

