#################################
# ALB
#################################

resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = var.alb_security_group_ids
  subnets            = var.public_subnet_ids
}

#################################
# NLB DNS -> IP 조회
#################################

data "dns_a_record_set" "rosa_nlb" {
  host = var.rosa_nlb_dns_name
}

#################################
# Target Group (ALB -> NLB IP)
#################################

resource "aws_lb_target_group" "main" {
  name        = "${var.project_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    path                = "/healthz/ready"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

#################################
# Listener
#################################

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

#################################
# NLB IP들을 Target으로 등록
#################################

resource "aws_lb_target_group_attachment" "nlb_ips" {
  for_each         = toset(data.dns_a_record_set.rosa_nlb.addrs)
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = each.value
  port             = 80
}