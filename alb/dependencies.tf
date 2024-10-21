data "aws_route53_zone" "this" {
  name         = var.public_domain
  private_zone = false
}
