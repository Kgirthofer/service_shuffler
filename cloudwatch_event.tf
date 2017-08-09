# Scale Up

resource "aws_cloudwatch_event_rule" "scale_up" {
  name        = "${var.cluster_name}-asg-scale-up"
  description = "Capture each scale up"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.autoscaling"
  ],
  "detail-type": [
    "EC2 Instance Launch Successful"
  ],
  "detail": {
    "AutoScalingGroupName": [
      "${var.auto_scaling_group_name}"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "lambdaTriggerUp" {
  rule      = "${aws_cloudwatch_event_rule.scale_up.name}"
  target_id = "lamdaFunction"
  arn       = "${aws_lambda_function.lambda_shuffler.arn}"
}

# Scale Down

resource "aws_cloudwatch_event_rule" "scale_down" {
  name        = "${var.cluster_name}-asg-scale-down"
  description = "Capture each scale down"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.autoscaling"
  ],
  "detail-type": [
    "EC2 Instance Terminate Successful"
  ],
  "detail": {
    "AutoScalingGroupName": [
      "${var.auto_scaling_group_name}"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "lambdaTriggerDown" {
  rule      = "${aws_cloudwatch_event_rule.scale_down.name}"
  target_id = "lamdaFunction"
  arn       = "${aws_lambda_function.lambda_shuffler.arn}"
}

