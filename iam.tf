data "aws_iam_policy_document" "cloudwatchAccess" {
  statement {
    sid = "1"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
  statement {
    sid = "2"
    
    actions = [
      "ecs:DescribeServices",
      "ecs:UpdateService",
      "autoscaling:DescribeAutoScalingGroups"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatchAccess" {
  name   = "${var.lambda_name}-policy"
  path   = "/"
  policy = "${data.aws_iam_policy_document.cloudwatchAccess.json}"
}

resource "aws_iam_policy_attachment" "attachment" {
  name       = "ecs-attachment"
  roles      = ["${aws_iam_role.lambda_shuffler_role.name}"]
  policy_arn = "${aws_iam_policy.cloudwatchAccess.arn}"
}
