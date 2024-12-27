output "alb_security_group_arn" {
  description = "The ARN of the ALB security group"
  value       = module.alb_security_group.security_group_arn
}

output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = module.alb_security_group.security_group_id
}

output "alb_security_group_name" {
  description = "The name of the ALB security group"
  value       = module.alb_security_group.security_group_name
}