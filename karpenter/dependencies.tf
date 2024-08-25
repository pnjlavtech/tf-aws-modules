data "aws_availability_zones" "available" {}

data "aws_ecrpublic_authorization_token" "token" {
  provider = aws.virginia
}

# data "aws_eks_cluster" "eks_cluster_name" {
#   count = var.cluster_name == "dev-eks" ? 0 : 1
  
#   name = var.cluster_name
# }

data "aws_eks_cluster_auth" "cluster_auth" {
  count = var.cluster_name == "dev-eks" ? 0 : 1

  name = var.cluster_name
}