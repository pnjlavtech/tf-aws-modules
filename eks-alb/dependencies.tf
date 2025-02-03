# data "aws_acm_certificate" "acm_certificate_argo" {
#   count  = var.create_alb_for_argocd ? 1 : 0
#   domain = coalesce(var.public_domain, var.domain_name_argo)
# }

data "aws_route53_zone" "this" {
  name         = var.public_domain
  private_zone = false
}