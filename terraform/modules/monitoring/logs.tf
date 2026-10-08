resource "aws_cloudwatch_log_metric_filter" "backend_errors" {
  name = "${var.name}-backend-errors"
  log_group_name = local.backend_log_group
  pattern = "?\"Internal Server Error\" ?Traceback ?CRITICAL"

  metric_transformation {
    name = "BackendErrorCount"
    namespace = "${var.name}/Application"
    value = 1
  }
}

resource "aws_cloudwatch_metric_alarm" "backend_errors" {
    alarm_name = "${var.name}-backend-errors"
    alarm_description = "Backend logged 3 or more errors/tracebacks in 5 min"

    namespace = "${var.name}/Application"
    metric_name = "BackendErrorCount"

    statistic = "Sum"
    period = 300
    evaluation_periods = 1
    threshold = 3
    comparison_operator = "GreaterThanOrEqualToThreshold"
    treat_missing_data = "notBreaching"

    alarm_actions = [aws_sns_topic.alerts.arn]
    ok_actions = [aws_sns_topic.alerts.arn]
}