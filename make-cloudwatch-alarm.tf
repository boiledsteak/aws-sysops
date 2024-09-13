# Define the CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "memory_usage_alarm" {
  alarm_name                = "MemoryUsageHigh"
  alarm_description         = "Alarm when memory usage exceeds 39%"
  namespace                 = "custom/ns1"
  metric_name               = "mem-usage-test"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = 1
  period                    = 10  # 15 seconds
  threshold                 = 39
  statistic                 = "Average"
  unit                      = "Percent"

  dimensions = {
    InstanceName = "myinstance"
  }

  # Define actions to be taken when the alarm state is triggered
  alarm_actions = [
    # Put the ARN of the SNS topic or other action here
    # e.g., arn:aws:sns:ap-southeast-1:123456789012:MySNSTopic
  ]

  ok_actions = [
    # Optional: Actions to take when the alarm state returns to OK
  ]

  insufficient_data_actions = [
    # Optional: Actions to take when there is insufficient data
  ]
}
