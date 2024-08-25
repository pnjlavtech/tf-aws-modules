provider "aws" {
  region = "us-east-1"
  alias  = "virginia"
}

provider "aws" {
  region = "us-west-2"
  alias  = "oregon"
}

 terraform {
  required_version = ">= 1.3.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.50"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.13.1"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0"
    }
  }
}




# obtain a cluster token for providers, tokens are short lived (15 minutes)
# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.eks_cluster_name.endpoint
#   cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster_name.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.cluster_auth.token
# }



# obtain a cluster token for providers, tokens are short lived (15 minutes)
provider "kubectl" {
  apply_retry_count      = 5
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
  # token                  = data.aws_eks_cluster_auth.cluster_auth[0].token != null ? data.aws_eks_cluster_auth.cluster_auth[0].token : ""
  # token                  = var.cluster_auth_token == "" ? "" : data.aws_eks_cluster_auth.cluster_auth[0].token
  token                  = var.cluster_name == "eks" ? "" : data.aws_eks_cluster_auth.cluster_auth[0].token
  load_config_file       = false
}


# obtain a cluster token for providers, tokens are short lived (15 minutes)
provider "helm" {
  kubernetes {
    host                   = var.cluster_endpoint
    cluster_ca_certificate = base64decode(var.cluster_certificate_authority_data)
    # token                  = data.aws_eks_cluster_auth.cluster_auth[0].token != null ? data.aws_eks_cluster_auth.cluster_auth[0].token : ""
    # token                  = var.cluster_auth_token == "" ? "" : data.aws_eks_cluster_auth.cluster_auth[0].token
    token                  = var.cluster_name == "eks" ? "" : data.aws_eks_cluster_auth.cluster_auth[0].token
  }
}



locals {
  tags = {
    Clustername = var.cluster_name
    GithubRepo  = "tf-aws-modules"
    module      = "eks-karpenter"
  }
}


################################################################################
# Karpenter
################################################################################

module "karpenter" {
  source = "terraform-aws-modules/eks/aws//modules/karpenter"

  cluster_name = var.cluster_name

  enable_pod_identity             = true
  create_pod_identity_association = true

  # Used to attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  tags = local.tags
}

module "karpenter_disabled" {
  source = "terraform-aws-modules/eks/aws//modules/karpenter"

  create = false
}

# Check this for update notes first:
# https://karpenter.sh/docs/upgrading/upgrade-guide/#crd-upgrades
resource "helm_release" "karpenter-crd" {
  namespace           = "kube-system"
  create_namespace    = false
  cleanup_on_fail     = true
  name                = "karpenter-crd"
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart               = "karpenter-crd"
  version             = var.chart_version
  wait                = true
  values              = []
}

resource "helm_release" "karpenter" {
  depends_on          = [ helm_release.karpenter-crd ]
  namespace           = "kube-system"
  create_namespace    = false
  cleanup_on_fail     = true
  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart               = "karpenter"
  version             = var.chart_version
  wait                = false
  
  # The crds are controlled by the karpenter-crd chart above.
  skip_crds = true

  values = [
    <<-EOT
    serviceAccount:
      name: ${module.karpenter.service_account}
    settings:
      clusterName: ${var.cluster_name}
      clusterEndpoint: ${var.cluster_endpoint}
      interruptionQueue: ${module.karpenter.queue_name}
    EOT
  ]
}


resource "kubectl_manifest" "karpenter_node_class" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1beta1
    kind: EC2NodeClass
    metadata:
      name: default
      annotations:
        meta.helm.sh/release-name: karpenter-crd
        meta.helm.sh/release-namespace: kube-system
      labels:
        app.kubernetes.io/managed-by: Helm
    spec:
      amiFamily: AL2023
      role: ${module.karpenter.node_iam_role_name}
      subnetSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${var.cluster_name}
      securityGroupSelectorTerms:
        - tags:
            karpenter.sh/discovery: ${var.cluster_name}
      tags:
        karpenter.sh/discovery: ${var.cluster_name}
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}


resource "kubectl_manifest" "karpenter_node_pool" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1beta1
    kind: NodePool
    metadata:
      name: default
      annotations:
        meta.helm.sh/release-name: karpenter-crd
        meta.helm.sh/release-namespace: kube-system
      labels:
        app.kubernetes.io/managed-by: Helm
    spec:
      template:
        spec:
          nodeClassRef:
            name: default
          requirements:
            - key: "karpenter.k8s.aws/instance-category"
              operator: In
              values: ["c", "m", "r"]
            - key: "karpenter.k8s.aws/instance-cpu"
              operator: In
              values: ["4", "8", "16", "32"]
            - key: "karpenter.k8s.aws/instance-hypervisor"
              operator: In
              values: ["nitro"]
            - key: "karpenter.k8s.aws/instance-generation"
              operator: Gt
              values: ["2"]
      limits:
        cpu: 1000
      disruption:
        consolidationPolicy: WhenEmpty
        consolidateAfter: 30s
  YAML

  depends_on = [
    kubectl_manifest.karpenter_node_class
  ]
}