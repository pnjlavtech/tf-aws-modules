locals {
  public_domain    = var.public_domain
  domain_name_argo = coalesce(var.domain_name_argo, "argocd.eks.${var.region}.${var.env}.${local.public_domain}")
 
}


module "alb_sg_argo" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name        = "alb-sg-${var.name_argo}"
  description = "Security group for ARGO ALB"
  vpc_id      = var.vpc_id

  use_name_prefix = false

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Port 80 (ipv4)"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Port 443 (ipv4)"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "User-service ports (ipv4)"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  tags = merge(var.tags, {
    "Name" = "alb-sg-${var.name_argo}"
  })
}


resource "aws_lb" "alb_argo" {
  count = var.create_alb_for_argocd ? 1 : 0

  name               = var.name_argo
  internal           = true
  load_balancer_type = "application"
  security_groups    = [module.alb_sg_argo.security_group_id]
  subnets            = var.private_subnets

  enable_deletion_protection = var.alb_enable_deletion_protection

  tags = merge(var.tags, {
    "Name" = "alb-${var.name_argo}"
  })
}



resource "aws_lb_target_group" "alb_tg_eks_blue_argo" {
  count = var.create_alb_for_argocd ? 1 : 0

  name             = "tg-eks-blue-${var.name_argo}"
  target_type      = "ip"
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"
  vpc_id           = var.vpc_id

  health_check {
    path                = var.alb_tg_health_check_path
    healthy_threshold   = var.alb_tg_health_check_healthy_threshold
    unhealthy_threshold = var.alb_tg_health_check_unhealthy_threshold
    interval            = var.alb_tg_health_check_interval
  }

  tags = merge(var.tags, {
    "Name" = "tg-eks-blue-${var.name_argo}"
  })
}


resource "aws_lb_listener" "alb_listener_http_argo" {
  count = var.create_alb_for_argocd ? 1 : 0

  load_balancer_arn = aws_lb.alb_argo[0].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}


# output
# module.acm["argocd"].aws_acm_certificate.this[0] 

# what its looking for 
# data.aws_acm_certificate.acm_certificate_argo[0]

resource "aws_lb_listener" "alb_listener_https_argo" {
  count = var.create_alb_for_argocd ? 1 : 0

  load_balancer_arn = aws_lb.alb_argo[0].arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = coalesce(var.argo_cert_arn, "arn:aws:acm:us-west-2:123456712345:certificate/0761d356-0614-4218-8ef2-5924efc25a94")
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "alb_listener_https_rules_argo" {
  count = var.create_alb_for_argocd ? 1 : 0

  listener_arn = aws_lb_listener.alb_listener_https_argo[0].arn
  priority     = 10

  action {
    type = "forward"
    forward {
      stickiness {
        duration = 1
        enabled  = false
      }
      target_group {
        arn    = aws_lb_target_group.alb_tg_eks_blue_argo[0].arn
        weight = var.alb_traffic_weight_to_eks_blue_argo
      }
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  condition {
    host_header {
      values = [var.domain_name_argo]
    }
  }
}
