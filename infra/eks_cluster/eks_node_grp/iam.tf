locals {
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"]
}

data "aws_iam_policy_document" "eks_node_assume_role_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "eks_node_role" {
  name               = "${var.node_group_name}-node-role"
  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role_policy.json
}
resource "aws_iam_policy_attachment" "eks_node_managed_policy_attachment" {
  for_each   = toset(local.managed_policy_arns)
  name       = replace("${var.node_group_name}_managed_policy_attachement","-","_")
  roles      = [aws_iam_role.eks_node_role.name]
  policy_arn = each.value
}
resource "aws_iam_policy_attachment" "eks_node_policy_attachment" {
  count   = length(var.additional_policies)
  name       = replace("${var.node_group_name}_policy_attachement","-","_")
  roles      = [aws_iam_role.eks_node_role.name]
  policy_arn = var.additional_policies[count.index]
}