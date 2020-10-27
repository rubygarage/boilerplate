resource "aws_lb" "this" {
  name                       = module.variables.project_name_env
  subnets                    = module.global.default_subnet_ids
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.load_balancer.id]
  enable_deletion_protection = true
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "this" {
  name                 = aws_lb.this.name
  port                 = "8080"
  protocol             = "HTTP"
  vpc_id               = module.global.default_vpc_id
  deregistration_delay = 30

  health_check {
    path                = "/health_check"
    port                = "80"
    protocol            = "HTTP"
    timeout             = 5
    interval            = 30
    unhealthy_threshold = 2
    healthy_threshold   = 2
    matcher             = "200"
  }

  stickiness {
    type    = "lb_cookie"
    enabled = true
  }
}
