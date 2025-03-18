output "non_prod_name_servers" {
  value = aws_route53_zone.this.name_servers
}

output "aws_route53_zone_id" {
  value = aws_route53_zone.this.zone_id
}
