resource "aws_lb" "alb_argo" {
  count = var.create_alb_for_argocd ? 1 : 0

  name               = var.name_argo
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg_argo[0].id]
  subnets            = var.private_subnets

  enable_deletion_protection = var.alb_enable_deletion_protection

  tags = merge(var.tags, {
    "alb_name" = aws_lb.alb_argo.name
  })
}

resource "aws_security_group" "alb_sg_argo" {
  count = var.create_alb_for_argocd ? 1 : 0

  name        = "${var.name_argo}-alb-sg"
  description = "Allow connections to ${var.name_argo}"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    "alb_sg_name" = aws_lb.alb_argo.name
  })
}

resource "aws_security_group_rule" "alb_sg_rules_argo" {
  for_each = {
    for k, v in var.alb_sg_rules_argo :
    k => v
    if var.create_alb_for_argocd
  }

  # Required
  security_group_id = aws_security_group.alb_sg_argo[0].id
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  type              = each.value.type

  # Optional
  description              = lookup(each.value, "description", null)
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  self                     = lookup(each.value, "self", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}

resource "aws_lb_target_group" "alb_tg_eks_blue_argo" {
  count = var.create_alb_for_argocd ? 1 : 0

  name             = "${var.name_argo}-tg-eks-blue"
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
    "alb_tg_name" = aws_lb_target_group.alb_tg_eks_blue_argo.name
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

resource "aws_lb_listener" "alb_listener_https_argo" {
  count = var.create_alb_for_argocd ? 1 : 0

  load_balancer_arn = aws_lb.alb_argo[0].arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = data.aws_acm_certificate.acm_certificate_argo[0].arn

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
