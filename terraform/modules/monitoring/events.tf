resource "aws_cloudwatch_event_rule" "ecs_service_events" {
  name        = "${var.name}-ecs-service-events"
  description = "ECS service WARN/ERROR events for the ${var.name} cluster"

  event_pattern = jsonencode({
    source        = ["aws.ecs"]
    "detail-type" = ["ECS Service Action"]
    detail = {
      eventType  = ["WARN", "ERROR"]
      clusterArn = [local.cluster_arn]
    }
  })
}

resource "aws_cloudwatch_event_target" "ecs_service_events_to_sns" {
  rule = aws_cloudwatch_event_rule.ecs_service_events.name
  arn  = aws_sns_topic.alerts.arn

  input_transformer {
    input_paths = {
      type    = "$.detail.eventType"
      event   = "$.detail.eventName"
      service = "$.resources[0]"
      time    = "$.time"
    }
    input_template = "\"ECS <type>: <event> on <service> at <time>\""
  }
}