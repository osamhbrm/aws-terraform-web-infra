resource "aws_autoscaling_group" "web_asg" {
  name                = "web-asg"
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  

  vpc_zone_identifier = [aws_subnet.private1.id, aws_subnet.private2.id]
  

  target_group_arns   = [aws_lb_target_group.web_tg.arn]

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