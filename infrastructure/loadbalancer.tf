resource "aws_lb" "application_lb" {
  name               = "application-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.load_balancer_sg.id]
  subnets            = aws_subnet.public.*.id

  enable_deletion_protection = true
  tags = {
    Name = "application-lb"
  }
}

resource "aws_lb_target_group" "group" {
  name     = "alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.devops-roadmap.id
  
  
  # Alter the destination of the health check to be the health URL.
  health_check {
    path = "/"
    port = 80
  }
}

resource "aws_lb_target_group_attachment" "target_attachment" {
  count            = length(aws_instance.service-box) 
  target_group_arn = aws_lb_target_group.group.id
  target_id        = aws_instance.service-box[count.index].id
  port             = 80
}

resource "aws_lb_listener" "listener_http" {
  load_balancer_arn = aws_lb.application_lb.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.group.id
    type             = "forward"
  }
}

# Redirect HTTP to HTTPS

# resource "aws_lb_listener" "listener_http" {
#   load_balancer_arn = aws_lb.application_lb.id
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }

# resource "aws_lb_listener" "listener_https" {
#   load_balancer_arn = aws_lb.application_lb.id
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "${var.certificate_arn}"
#   default_action {
#     target_group_arn = aws_alb_target_group.group.id
#     type             = "forward"
#   }
# }
