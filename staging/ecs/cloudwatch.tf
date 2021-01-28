// Logs
resource "aws_cloudwatch_log_group" "mysfits_fargate" {
  name = "mysfits-fargate"

  retention_in_days = 1

  tags = {
    Name        = "mysfits-fargate"
    Terraform   = "true"
    Environment = "staging"
  }
}

// Alarms for ECS service autoscaling
resource "aws_cloudwatch_metric_alarm" "mysfits_like_scaleup_alarm" {
  actions_enabled     = "true"
  alarm_name          = "LikeScaleUpAlarm"
  alarm_description   = "Scale out containers if ALB RequestCount SUM metric > 100"
  alarm_actions       = [aws_appautoscaling_policy.mysfits_like_scaleup_policy.arn]
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "RequestCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "100"

  dimensions = {
    LoadBalancer = module.alb.alb_arn_suffix
    TargetGroup  = aws_lb_target_group.mysfits_like.arn_suffix
  }

}

resource "aws_cloudwatch_metric_alarm" "mysfits_like_scaledown_alarm" {
  actions_enabled     = "true"
  alarm_name          = "LikeScaleDownAlarm"
  alarm_description   = "Scale in containers if ALB RequestCount SUM metric < 100"
  alarm_actions       = [aws_appautoscaling_policy.mysfits_like_scaledown_policy.arn]
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "RequestCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Sum"
  threshold           = "100"

  dimensions = {
    LoadBalancer = module.alb.alb_arn_suffix
    TargetGroup  = aws_lb_target_group.mysfits_like.arn_suffix
  }

}
