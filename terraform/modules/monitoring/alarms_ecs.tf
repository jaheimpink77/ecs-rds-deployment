resource "aws_cloudwatch_metric_alarm" "ecs_cpu" {
  for_each = local.ecs_services

  alarm_name = "${var.name}-${each.key}-cpu-high"
  alarm_description = "Average CPU for the ${each.key} service above 80% for 10 min"

  namespace = "AWS/ECS"
  metric_name = "CPUUtilization"
  dimensions = {
    ClusterName = local.cluster_name
    ServiceName = each.value
  }

  statistic = "Average"
  period = 300
  evaluation_periods = 2
  threshold = 80
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data = "notBreaching"

  alarm_actions = [aws_sns_topic.alerts]
  ok_actions = [aws_sns_topic.alerts]
}

resource "aws_cloudwatch_metric_alarm" "ecs_memory" {
  for_each = local.ecs_services

  alarm_name = "${var.name}-${each.key}-memory-high"
  alarm_description = "Average memory for the ${each.key} service above 80% for 10 min"

  namespace = "AWS/ECS"
  metric_name = "MemoryUtilization"
  dimensions = {
    ClusterName = local.cluster_name
    ServiceName = each.value
  }

  statistic = "Average"
  period = 300
  evaluation_periods = 2
  threshold = 80
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data = "notBreaching"

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions = [aws_sns_topic.alerts.arn]
}