output "alb_security_group_arn" {
  description = "The ARN of the ALB security group"
  value       = module.alb_security_group.arn
}

output "alb_security_group_id" {
  description = "The ID of the ALB security group"
  value       = module.alb_security_group.id
}

# output "alb_security_group_vpc_id" {
#   description = "The VPC ID"
#   value       = module.alb_security_group.vpc_id 
# }

output "alb_security_group_name" {
  description = "The name of the ALB security group"
  value       = module.alb_security_group.name
}

# output "alb_security_group_description" {
#   description = "The description of the ALB security group"
#   value       = module.alb_security_group.description
# }