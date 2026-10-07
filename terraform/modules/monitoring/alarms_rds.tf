resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name = "${var.name}-rds-cpu-high"
  alarm_description = "RDS average CPU above 80% for 10 min"

  namespace = "AWS/RDS"
  metric_name = "CPUUtilization"
  dimensions = {
    DBInstanceIdentifier = local.db_id
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

resource "aws_cloudwatch_metric_alarm" "rds_free_storage" {
  alarm_name = "${var.name}-rds-free-stroage-low"
  alarm_description = "RDS free storage below 3 GiB"

  namespace = "AWS/RDS"
  metric_name = "FreeStorageSpace"
  dimensions = {
    DBInstanceIdentifier = local.db_id
  }

  statistic = "Minimum"
  period = 300
  evaluation_periods = 1
  threshold = 2147483648
  comparison_operator = "LessThanThreshold"
  treat_missing_data = "notBreaching"

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "rds_free_memory" {
  alarm_name = "${var.name}-rds-free-memory-low"
  alarm_description = "RDS freeable memory below 100 MiB for 15 min"

  namespace = "AWS/RDS"
  metric_name = "FreeableMemory"
  dimensions = {
    DBInstanceIdentifier = local.db_id
  }

  statistic = "Average" 
  period = 300
  evaluation_periods = 3
  threshold = 104857600
  comparison_operator = "LessThanThreshold"
  treat_missing_data = "notBreaching"

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "rds_connections" {
  alarm_name = "${var.name}-rds-connections-high"
  alarm_description = "RDS connection count at or above 80 for 10 min"

  namespace = "AWS/RDS"
  metric_name = "DatabaseConnections"
  dimensions = {
    DBInstanceIdentifier = local.db_id
  }

  statistic = "Maximum" 
  period = 300
  evaluation_periods = 2
  threshold = 80
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data = "notBreaching"

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions = [aws_sns_topic.alerts.arn]
}