resource "aws_eks_node_group" "sample-cluster-nodegrp" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = var.max_unavailable
  }

  depends_on = [aws_iam_policy_attachment.eks_node_policy_attachment]
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
