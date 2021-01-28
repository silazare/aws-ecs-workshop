// Autoscaling resources for ECS FARGATE
resource "aws_appautoscaling_target" "mysfits_like" {

  max_capacity       = 5
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.mysfits_like.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  // ECS service autoscaling always overwrite custom IAM Role in Terraform to default - AWSServiceRoleForApplicationAutoScaling_ECSService
  #role_arn           = aws_iam_role.ecs_autoscaling.arn

  depends_on = [aws_ecs_service.mysfits_like]
}

resource "aws_appautoscaling_policy" "mysfits_like_scaleup_policy" {
  name               = "mysfits-like-scaleup-policy"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.mysfits_like.resource_id
  scalable_dimension = aws_appautoscaling_target.mysfits_like.scalable_dimension
  service_namespace  = aws_appautoscaling_target.mysfits_like.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      # Step is 0 because it is controlled by CloudWatch alarm
      metric_interval_lower_bound = 0
      scaling_adjustment          = 5
    }
  }

  depends_on = [aws_appautoscaling_target.mysfits_like]

}

resource "aws_appautoscaling_policy" "mysfits_like_scaledown_policy" {
  name               = "mysfits-like-scaledown-policy"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.mysfits_like.resource_id
  scalable_dimension = aws_appautoscaling_target.mysfits_like.scalable_dimension
  service_namespace  = aws_appautoscaling_target.mysfits_like.service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      # Step is 0 because it is controlled by CloudWatch alarm
      metric_interval_upper_bound = 0
      scaling_adjustment          = -5
    }
  }

  depends_on = [aws_appautoscaling_target.mysfits_like]

}