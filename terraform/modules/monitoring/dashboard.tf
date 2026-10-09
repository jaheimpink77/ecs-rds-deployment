resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = "${var.name}-overview"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "alarm", x = 0, y = 0, width = 24, height = 3
        properties = {
          title = "Alarm status"
          alarms = concat(
            [
              aws_cloudwatch_metric_alarm.alb_frontend_target_5xx.arn,
              aws_cloudwatch_metric_alarm.alb_5xx.arn,
              aws_cloudwatch_metric_alarm.alb_unhealthy_hosts.arn,
              aws_cloudwatch_metric_alarm.alb_no_hosts_healthy.arn,
              aws_cloudwatch_metric_alarm.alb_p95_latency.arn,
              aws_cloudwatch_metric_alarm.rds_connections.arn,
              aws_cloudwatch_metric_alarm.rds_cpu.arn,
              aws_cloudwatch_metric_alarm.rds_free_memory.arn,
              aws_cloudwatch_metric_alarm.rds_free_storage.arn,
              aws_cloudwatch_metric_alarm.backend_errors.arn,
            ],
            [for a in aws_cloudwatch_metric_alarm.ecs_cpu : a.arn],
            [for a in aws_cloudwatch_metric_alarm.ecs_memory : a.arn],
          )
        }
      },
      {
        type = "metric", x = 0, y = 3, width = 12, height = 6
        properties = {
          title   = "ALB (frontend) requests and 5xx"
          region  = local.region
          view    = "timeSeries"
          stacked = false
          period  = 300
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", local.lb_suffix, { stat = "Sum", label = "Requests" }],
            [".", "HTTPCode_Target_5XX_Count", ".", ".", { stat = "Sum", label = "Target 5xx" }],
            [".", "HTTPCode_ELB_5XX_Count", ".", ".", { stat = "Sum", label = "ELB 5xx" }],
          ]
        }
      },
      {
        type = "metric", x = 12, y = 3, width = 12, height = 6
        properties = {
          title   = "ALB (frontend): p95 response time (s)"
          region  = local.region
          view    = "timeSeries"
          stacked = false
          period  = 300
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", local.lb_suffix, { stat = "p95", label = "p95" }],
          ]
          annotations = {
            horizontal = [{ label = "Alarm threshold", value = 2 }]
          }
        }
      },
      {
        type = "metric", x = 0, y = 9, width = 12, height = 6
        properties = {
          title   = "ECS CPU utilisation (%)"
          region  = local.region
          view    = "timeSeries"
          stacked = false
          period  = 300
          metrics = [
            for name, svc in local.ecs_services :
            ["AWS/ECS", "CPUUtilization", "ClusterName", local.cluster_name, "ServiceName", svc, { stat = "Average", label = name }]
          ]
          annotations = {
            horizontal = [{ label = "Alarm threshold", value = 80 }]
          }
        }
      },
      {
        type = "metric", x = 12, y = 9, width = 12, height = 6
        properties = {
          title   = "ECS memory utilisation (%)"
          region  = local.region
          view    = "timeSeries"
          stacked = false
          period  = 300
          metrics = [
            for name, svc in local.ecs_services :
            ["AWS/ECS", "MemoryUtilization", "ClusterName", local.cluster_name, "ServiceName", svc, { stat = "Average", label = name }]
          ]
          annotations = {
            horizontal = [{ label = "Alarm threshold", value = 80 }]
          }
        }
      },
      {
        type = "metric", x = 0, y = 15, width = 6, height = 6
        properties = {
          title   = "RDS CPU (%)"
          region  = local.region
          view    = "timeSeries"
          stacked = false
          period  = 300
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", local.db_id, { stat = "Average" }],
          ]
        }
      },
      {
        type = "metric", x = 6, y = 15, width = 6, height = 6
        properties = {
          title   = "RDS connections"
          region  = local.region
          view    = "timeSeries"
          stacked = false
          period  = 300
          metrics = [
            ["AWS/RDS", "DatabaseConnections", "DBInstanceIdentifier", local.db_id, { stat = "Maximum" }],
          ]
        }
      },
      {
        type = "metric", x = 12, y = 15, width = 6, height = 6
        properties = {
          title   = "RDS free storage (bytes)"
          region  = local.region
          view    = "timeSeries"
          stacked = false
          period  = 300
          metrics = [
            ["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", local.db_id, { stat = "Minimum" }],
          ]
        }
      },
      {
        type = "metric", x = 18, y = 15, width = 6, height = 6
        properties = {
          title   = "RDS freeable memory (bytes)"
          region  = local.region
          view    = "timeSeries"
          stacked = false
          period  = 300
          metrics = [
            ["AWS/RDS", "FreeableMemory", "DBInstanceIdentifier", local.db_id, { stat = "Average" }],
          ]
        }
      },
      {
        type = "log", x = 0, y = 21, width = 24, height = 6
        properties = {
          title  = "Recent backend errors"
          region = local.region
          view   = "table"
          query  = "SOURCE '${local.backend_log_group}' | fields @timestamp, @message | filter @message like /Internal Server Error|Traceback|CRITICAL/ | sort @timestamp desc | limit 20"
        }
      }
    ]
  })
}
