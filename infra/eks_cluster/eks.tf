
resource "aws_eks_cluster" "eks-cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    security_group_ids      = var.security_group_ids
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }


  access_config {
    authentication_mode = var.authentication_mode
    bootstrap_cluster_creator_admin_permissions = var.bootstrap_creator_admin_permissions
  }
  enabled_cluster_log_types = var.log_types

  depends_on = [
    aws_iam_policy_attachment.EKS_cluster_policy,
    aws_cloudwatch_log_group.eks-cw-log
  ]
}

resource "aws_eks_addon" "eks-addon" {
  for_each = toset(var.cluster_addons)
  cluster_name = aws_eks_cluster.eks-cluster.name
  addon_name   = each.value
}
resource "aws_eks_addon" "coredns-addon" {
  count = var.create_coredns ? 1 : 0
  cluster_name = aws_eks_cluster.eks-cluster.name
  addon_name   = "coredns"
  depends_on = [ module.eks-node-group ]
}


resource "aws_cloudwatch_log_group" "eks-cw-log" {
  name              = "/aws/eks/${var.eks_cluster_name}/cluster"
  retention_in_days = 7
}

