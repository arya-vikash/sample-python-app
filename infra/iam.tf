
data "aws_iam_policy_document" "publish_cloudwatch_logs" {
  statement {
    actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",
        "logs:DescribeLogGroups"
    ]
    effect  = "Allow"
    resources = [
      "arn:aws:logs:*:*:*"
    ]

  }
}
resource "aws_iam_policy" "publish_cloudwatch_logs" {
  name        = "publish_cloudwatch_logs"
  description = "policy to publish to cw logs"
  policy = data.aws_iam_policy_document.publish_cloudwatch_logs.json
}