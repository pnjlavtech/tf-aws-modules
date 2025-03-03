output "non_prod_name_servers" {
  value = aws_route53_zone.this.name_servers
}
