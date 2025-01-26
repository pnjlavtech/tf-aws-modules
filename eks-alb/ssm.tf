resource "aws_ssm_parameter" "alb_tg_eks_blue_argo_arn" {
  count = var.create_alb_for_argocd ? 1 : 0

  name  = "/${var.env}/${var.region}/eks/${var.eks_clus}/tg-argo-arn"
  type  = "String"
  value = aws_lb_target_group.alb_tg_eks_blue_argo[0].arn
}

