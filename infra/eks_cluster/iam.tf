data "aws_iam_policy_document" "eks_cluster_assume_role_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.eks_cluster_name}_role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role_policy.json
}
resource "aws_iam_policy_attachment" "EKS_cluster_policy" {
  name       = "${var.eks_cluster_name}_policy"
  roles      = [aws_iam_role.eks_cluster_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

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

resource "aws_iam_policy_attachment" "EKS_cluster_cw_policy" {
  name       = "${var.eks_cluster_name}_cw_policy"
  roles      = [aws_iam_role.eks_cluster_role.name]
  policy_arn = aws_iam_policy.publish_cloudwatch_logs.arn
}
