resource "aws_lb" "application_lb" {
  name               = "application-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sg.id]
  subnets            = aws_subnet.public.*.id

  # enable_deletion_protection = true
  tags = {
    Name = "application-lb"
  }
}

# Application Target group
resource "aws_lb_target_group" "app_group" {
  name     = "app-target-group"
  port     = var.application_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.devops-roadmap.id


  # Alter the destination of the health check to be the health URL.
  health_check {
    path = "/"
    port = var.application_port
  }
}

resource "aws_lb_target_group_attachment" "app_target_attachment" {
  count            = length(aws_instance.service-box)
  target_group_arn = aws_lb_target_group.app_group.id
  target_id        = aws_instance.service-box[count.index].id
  port             = var.application_port
}

# Registry Target group
resource "aws_lb_target_group" "registry_group" {
  name     = "registry-target-group"
  port     = var.registry_port
  protocol = "HTTPS"
  vpc_id   = aws_vpc.devops-roadmap.id

  # change HC later.
  health_check {
    path = "/debug/health"
    protocol = "HTTPS"
    port = 5000
  }
}

resource "aws_lb_target_group_attachment" "registry_target_attachment" {
  count            = length(aws_instance.service-box)
  target_group_arn = aws_lb_target_group.registry_group.id
  target_id        = aws_instance.service-box[count.index].id
  port             = var.registry_port
}

resource "aws_lb_listener_rule" "registry_lb_rules" {
  listener_arn = aws_lb_listener.listener_https.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.registry_group.arn
  }

  condition {
    path_pattern {
      values = ["/v2/*"]
    }
  }
}

# Redirect HTTP to HTTPS
resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_lb.application_lb.id
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

resource "aws_lb_listener" "listener_https" {
  load_balancer_arn = aws_lb.application_lb.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn
  default_action {
    target_group_arn = aws_lb_target_group.app_group.id
    type             = "forward"
  }
}
