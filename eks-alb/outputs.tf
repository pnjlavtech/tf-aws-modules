output "alb_security_group_argo_id" {
  description = "The ID of the ALB security group"
  value       = module.alb_sg_argo.security_group_id
}