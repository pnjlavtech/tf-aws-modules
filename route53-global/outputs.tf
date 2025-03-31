output "route53_zone_name_servers" {
  description = "Name servers of Route53 zone"
  value       = module.zones.route53_zone_name_servers
}

output "route53_zone_zone_arn" {
  description = "Map from zone name to zone ARN of Route53 zones"
  value = { for zone_name, arn in module.zones.route53_zone_zone_arn :
    zone_name => arn
  }
}
