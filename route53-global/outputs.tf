output "route53_zone_name_servers" {
  description = "Name servers of Route53 zone"
  value       = module.zones.route53_zone_name_servers
}

output "route53_zone_zone_arn" {
  description = "Zone ARN of Route53 zone"
  value       = module.zones.route53_zone_zone_arn
}

