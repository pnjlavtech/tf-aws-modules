data "aws_availability_zones" "available" {}

data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

data "aws_eks_cluster" "eks_cluster_name" {
  name = var.eks_fname
}

data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.eks_fname
}