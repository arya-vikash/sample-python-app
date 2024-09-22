module "eks-node-group" {
  source = "./eks_node_grp"

  node_group_name = "${var.eks_cluster_name}-node-grp"
  cluster_name = aws_eks_cluster.eks-cluster.name
  subnet_ids = var.subnet_ids
  additional_policies = var.additional_policies
}
