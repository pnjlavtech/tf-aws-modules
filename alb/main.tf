terraform {
  required_version = ">= 1.3.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.50"
    }
  }
}



module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = ">= 9.11.1"

  name     = var.alb_name
  vpc_id   = var.vpc_id
  subnets  = var.public_subnets

  # For example only
  enable_deletion_protection = false

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 82
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 445
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = var.vpc_cidr_block
    }
  }

  # access_logs = {
  #   bucket = module.log_bucket.s3_bucket_id
  #   prefix = "access-logs"
  # }

  # connection_logs = {
  #   bucket  = module.log_bucket.s3_bucket_id
  #   enabled = true
  #   prefix  = "connection-logs"
  # }

  client_keep_alive = 7200

  tags = var.tags

  listeners = {
    http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }

      # rules = {
      #   ex-fixed-response = {
      #     priority = 3
      #     actions = [{
      #       type         = "fixed-response"
      #       content_type = "text/plain"
      #       status_code  = 200
      #       message_body = "This is a fixed response"
      #     }]

      #     conditions = [{
      #       http_header = {
      #         http_header_name = "x-Gimme-Fixed-Response"
      #         values           = ["yes", "please", "right now"]
      #       }
      #     }]
      #   }
      # }

    }

    https = {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
      certificate_arn = var.acm_certificate_arn

      forward = {
        target_group_key = "karpenter_tg"
      }

      # rules = {
      #   ex-fixed-response = {
      #     priority = 3
      #     actions = [{
      #       type         = "fixed-response"
      #       content_type = "text/plain"
      #       status_code  = 200
      #       message_body = "This is a fixed response"
      #     }]

      #     conditions = [{
      #       http_header = {
      #         http_header_name = "x-Gimme-Fixed-Response"
      #         values           = ["yes", "please", "right now"]
      #       }
      #     }]
      #   }
      #   }

      }
    }


  target_groups = {

    arcocd_tg = {
      name_prefix                       = "h2"
      protocol                          = "HTTP"
      port                              = 443
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_algorithm_type     = "weighted_random"
      load_balancing_anomaly_mitigation = "on"
      load_balancing_cross_zone_enabled = false

      target_group_health = {
        dns_failover = {
          minimum_healthy_targets_count = 2
        }
        unhealthy_state_routing = {
          minimum_healthy_targets_percentage = 50
        }
      }

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/healthz"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }

      protocol_version = "HTTP1"
      port             = 443
      
      tags = merge(var.tags, {"TargetGroupTag" = "argo_tg"})
    }

    private_tg = {
      name_prefix                       = "h1"
      protocol                          = "HTTP"
      port                              = 80
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_algorithm_type     = "weighted_random"
      load_balancing_anomaly_mitigation = "on"
      load_balancing_cross_zone_enabled = false

      target_group_health = {
        dns_failover = {
          minimum_healthy_targets_count = 2
        }
        unhealthy_state_routing = {
          minimum_healthy_targets_percentage = 50
        }
      }

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/healthz"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }

      protocol_version = "HTTP1"
      # target_id        = var.karpenter_node_group
      port             = 80
      
      tags = merge(var.tags, {"TargetGroupTag" = "private_tg"})
    }

    public_tg = {
      name_prefix                       = "h2"
      protocol                          = "HTTP"
      port                              = 443
      target_type                       = "instance"
      deregistration_delay              = 10
      load_balancing_algorithm_type     = "weighted_random"
      load_balancing_anomaly_mitigation = "on"
      load_balancing_cross_zone_enabled = false

      target_group_health = {
        dns_failover = {
          minimum_healthy_targets_count = 2
        }
        unhealthy_state_routing = {
          minimum_healthy_targets_percentage = 50
        }
      }

      health_check = {
        enabled             = true
        interval            = 30
        path                = "/healthz"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }

      protocol_version = "HTTP1"
      port             = 443
      
      tags = merge(var.tags, {"TargetGroupTag" = "public_tg"})
    }
 }
}

resource "aws_ssm_parameter" "ssm_argocd_tg_arn" {
  name        = "/${var.env}/${var.region}/eks/${var.eks_clus}/argocd_tg_arn"
  description = "ArgoCD TG ARN"
  type        = "String"
  value       = module.alb.target_groups.arcocd_tg.arn
  tags        = merge(var.tags, {"ssm_param_name" = "ssm_argocd_tg_arn"})
}

resource "aws_ssm_parameter" "ssm_private_tg_arn" {
  name        = "/${var.env}/${var.region}/eks/${var.eks_clus}/private_tg_arn"
  description = "Private TG ARN"
  type        = "String"
  value       = module.alb.target_groups.private_tg.arn
  tags        = merge(var.tags, {"ssm_param_name" = "ssm_private_tg_arn"})
}

resource "aws_ssm_parameter" "ssm_public_tg_arn" {
  name        = "/${var.env}/${var.region}/eks/${var.eks_clus}/public_tg_arn"
  description = "Public TG ARN"
  type        = "String"
  value       = module.alb.target_groups.public_tg.arn
  tags        = merge(var.tags, {"ssm_param_name" = "ssm_public_tg_arn"})
}