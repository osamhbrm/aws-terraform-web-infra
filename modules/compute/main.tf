#ASG
resource "aws_autoscaling_group" "web_asg" {
  name             = "web-asg"
  desired_capacity = 2
  max_size         = 4
  min_size         = 2


  vpc_zone_identifier = [var.private1, var.private2]


  target_group_arns = [aws_lb_target_group.web_tg.arn]

  launch_template {
    id      = aws_launch_template.web_config.id
    version = "$Latest"
  }
  health_check_type         = "ELB"
  health_check_grace_period = 300
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
}
#LoadBalencer
resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "cpu-target-tracking"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}
resource "aws_lb" "main_alb" {
  name               = "main-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg]
  subnets            = [var.public1, var.public2]
}

resource "aws_lb_target_group" "web_tg" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.lb_target_group
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.main_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
#Launch Template
resource "aws_launch_template" "web_config" {
  name_prefix   = "web-config-"
  image_id      = data.aws_ami.image.image_id
  instance_type = "t2.micro"
  iam_instance_profile {
    name = var.instance_profile_web_profile
  }
  network_interfaces {
    security_groups = [var.private_sg]
  }


  user_data = filebase64("${path.module}/userdata.sh")
  lifecycle {
    create_before_destroy = true
  }
}
data "aws_ami" "image" {

  most_recent = true
  owners      = ["amazon"]


  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-6.1-x86_64*"]
  }
}
