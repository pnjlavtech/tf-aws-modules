terraform {
  required_version = ">= 1.3.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.50"
    }
  }
}



resource "aws_lb" "public_alb" {
  name               = "public-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg.id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = false
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.public_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.public_tg.arn
  }
}

resource "aws_lb" "private_alb" {
  name               = "private-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.alb_sg.id]
  subnets            = var.private_subnet_ids

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "public_tg" {
  name     = "public-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group" "private_tg" {
  name     = "private-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 30
    path                = "/healthz"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "private_http" {
  load_balancer_arn = aws_lb.private_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "karpenter_node_group_attachment" {
  for_each         = toset(var.karpenter_node_ids)
  target_group_arn = aws_lb_target_group.private_tg.arn
  target_id        = each.key
  port             = 80
}
