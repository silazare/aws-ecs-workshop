module "alb" {
  source = "git@github.com:silazare/terraform-aws-example.git//modules/alb?ref=v1.0.3"

  alb_name   = "mysfits-fargate-alb"
  vpc_id     = data.aws_vpc.custom.id
  subnet_ids = data.aws_subnet_ids.public.ids
}

resource "aws_lb_listener_rule" "mysfits_monolith" {
  listener_arn = module.alb.alb_http_listener_arn
  priority     = 101

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mysfits_monolith.arn
  }
}

resource "aws_lb_listener_rule" "mysfits_like" {
  listener_arn = module.alb.alb_http_listener_arn
  priority     = 100

  condition {
    path_pattern {
      values = ["/mysfits/*/like"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mysfits_like.arn
  }
}

resource "aws_lb_target_group" "mysfits_monolith" {
  name        = "mysfits-monolith"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.custom.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group" "mysfits_like" {
  name        = "mysfits-like"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.custom.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 10
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}
