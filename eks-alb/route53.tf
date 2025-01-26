resource "aws_route53_record" "dns_record_argo" {
  count = var.create_alb_for_argocd && var.create_dns_record_argo ? 1 : 0

  allow_overwrite = true

  zone_id = data.aws_route53_zone.route53_zone_argocd[0].id
  name    = var.domain_name_argo
  type    = "A"
  alias {
    evaluate_target_health = true
    name                   = aws_lb.alb_argo[0].dns_name
    zone_id                = aws_lb.alb_argo[0].zone_id
  }
}