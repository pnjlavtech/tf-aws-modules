################################################################################
# IAM Role
################################################################################

output "eks_alb_cluster_iam_role_name" {
  description = "IAM role name of the Amazon EKS LoadBalancer Controller Role"
  value       = aws_iam_role.eks_alb_controller_role.name
}

output "eks_alb_cluster_iam_role_arn" {
  description = "IAM role ARN of the Amazon EKS LoadBalancer Controller Role"
  value       = aws_iam_role.eks_alb_controller_role.arn
}

