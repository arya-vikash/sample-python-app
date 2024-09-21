resource "aws_cloudwatch_log_group" "this" {
  name = "eks-python-app-log-group"

  tags = {
    Application = "simple-py-app"
  }
}