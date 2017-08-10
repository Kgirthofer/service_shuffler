resource "aws_iam_role" "lambda_shuffler_role" {
  name = "${var.lambda_name}_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "lambda_shuffler" {
    function_name = "${var.lambda_name}"
    handler = "shuffler.lambda_handler"
    runtime = "python2.7"
    filename = "shuffler.zip"
    role = "${aws_iam_role.lambda_shuffler_role.arn}"
    source_code_hash = "${base64sha256(file("shuffler.zip"))}"
    timeout = 30
    environment {
      variables = {
        REGION       = "${var.region}"
        ASG_NAME     = "${var.auto_scaling_group_name}"
        CLUSTER_NAME = "${var.cluster_name}"
        SERVICE_NAME = "${var.service_name}"
      }
    }
}

# Scale Up Trigger
resource "aws_lambda_permission" "allow_cloudwatch_up" {
  statement_id   = "AllowExecutionFromCloudWatchUp"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.lambda_shuffler.function_name}"
  principal      = "events.amazonaws.com"
  source_arn     = "${aws_cloudwatch_event_rule.scale_up.arn}"
}

# Scale Down Trigger
resource "aws_lambda_permission" "allow_cloudwatch_down" {
  statement_id   = "AllowExecutionFromCloudWatchDown"
  action         = "lambda:InvokeFunction"
  function_name  = "${aws_lambda_function.lambda_shuffler.function_name}"
  principal      = "events.amazonaws.com"
  source_arn     = "${aws_cloudwatch_event_rule.scale_down.arn}"
}

