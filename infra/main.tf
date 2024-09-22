locals {
  common_resource_prefix = "DemoPyApp"
  cluster_name = "my-cluster"
  vpc-name = "${local.common_resource_prefix}-my-vpc"

}
module "vpc" {
  source                        = "terraform-aws-modules/vpc/aws"
  azs                           = var.azs
  cidr                          = var.cidr
  enable_nat_gateway            = var.enable_nat_gateway
  single_nat_gateway            = var.single_nat_gateway
  map_public_ip_on_launch       = var.map_public_ip_on_launch
  name                          = local.vpc-name
  private_subnets               = var.private_subnets
  public_subnets                = var.public_subnets
  private_dedicated_network_acl = var.private_dedicated_network_acl
  private_inbound_acl_rules     = var.private_inbound_acl_rules
  private_outbound_acl_rules    = var.private_outbound_acl_rules
  public_dedicated_network_acl  = var.public_dedicated_network_acl
  public_inbound_acl_rules      = var.public_inbound_acl_rules
  public_outbound_acl_rules     = var.public_outbound_acl_rules
  tags                          = var.tags
}


module "eks-cluster" {
  source = "./eks_cluster"

  eks_cluster_name   = "${local.common_resource_prefix}-${local.cluster_name}"
  subnet_ids     = module.vpc.public_subnets
  endpoint_public_access  = true
  endpoint_private_access = false
  cluster_addons = ["vpc-cni","eks-pod-identity-agent"]
  security_group_ids = [aws_security_group.eks_clsuter_sg.id]
  additional_policies = [aws_iam_policy.publish_cloudwatch_logs.arn]
}

resource "aws_cloudwatch_log_group" "this" {
  name = "eks-python-app-log-group"

  tags = {
    Application = "simple-py-app"
  }
}