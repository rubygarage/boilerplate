# Scale up

resource "aws_autoscaling_policy" "ec2-scaleup" {
  name                   = "${var.name}-cpu-scaleup-ec2"
  autoscaling_group_name = aws_autoscaling_group.cluster-instance.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "60"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu-scaleup-ec2" {
  alarm_name          = "${var.name}-cpu-scaleup-ec2"
  alarm_description   = "This metric monitors ec2 CPU utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "20"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.cluster-instance.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.ec2-scaleup.arn]
}

# Scale down

resource "aws_autoscaling_policy" "ec2-scaledown" {
  name                   = "${var.name}-cpu-scaledown-ec2"
  autoscaling_group_name = aws_autoscaling_group.cluster-instance.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu-scaledown-ec2" {
  alarm_name          = "${var.name}-cpu-scaledown-ec2"
  alarm_description   = "This metric monitors ec2 CPU utilization"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.cluster-instance.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.ec2-scaledown.arn]
}
