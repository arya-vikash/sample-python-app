# #eks cluster
# resource "aws_eks_cluster" "sample-cluster" {
#   name     = "Sample-cluster"
#   role_arn = aws_iam_role.eks_cluster_role.arn

#   vpc_config {
#     subnet_ids = module.vpc.public_subnets
#     endpoint_private_access = false
#     endpoint_public_access = true
#   }
#   #enabled_cluster_log_types = ["api", "audit"]
#   access_config{
#     authentication_mode = "API_AND_CONFIG_MAP"
#     bootstrap_cluster_creator_admin_permissions = true
#   }


#   # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
#   # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
#   depends_on = [
#     aws_iam_policy_attachment.EKS_cluster_policy,
#     aws_iam_policy_attachment.eks_node_policy_attachment,
#   ]
# }
# resource "aws_eks_addon" "vpc-cni" {
#   cluster_name = aws_eks_cluster.sample-cluster.name
#   addon_name   = "vpc-cni"
# }
# resource "aws_eks_addon" "coredns" {
#   cluster_name = aws_eks_cluster.sample-cluster.name
#   addon_name   = "coredns"
# }
# resource "aws_eks_addon" "pod-identity" {
#   cluster_name = aws_eks_cluster.sample-cluster.name
#   addon_name   = "eks-pod-identity-agent"
# }

# output "endpoint" {
#   value = aws_eks_cluster.sample-cluster.endpoint
# }

# output "kubeconfig-certificate-authority-data" {
#   value = aws_eks_cluster.sample-cluster.certificate_authority[0].data
# }


# ###EKS node group
# resource "aws_eks_node_group" "sample-cluster-nodegrp" {
#   cluster_name    = aws_eks_cluster.sample-cluster.name
#   node_group_name = "sample-cluster-nodegrp"
#   node_role_arn   = aws_iam_role.eks_node_role.arn
#   subnet_ids      = module.vpc.public_subnets

#   scaling_config {
#     desired_size = 2
#     max_size     = 2
#     min_size     = 1
#   }

#   update_config {
#     max_unavailable = 1
#   }

#   # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
#   # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
#   depends_on = [aws_iam_policy_attachment.eks_node_policy_attachment]
#   lifecycle {
#     ignore_changes = [scaling_config[0].desired_size]
#   }
# }