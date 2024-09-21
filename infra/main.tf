#Provider
provider "aws" {
  region = "eu-west-2"
}
#vpc 
module "vpc" {
  source                        = "terraform-aws-modules/vpc/aws"
  azs                           = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  cidr                          = "10.0.0.0/16"
  enable_nat_gateway            = true
  single_nat_gateway            = true
  map_public_ip_on_launch       = true
  name                          = "EKS-vpc"
  private_subnets               = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets                = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  private_dedicated_network_acl = true
  private_inbound_acl_rules = [
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 0,
      "protocol" : "-1",
      "rule_action" : "allow",
      "rule_number" : 100,
      "to_port" : 0
    }
  ]
  private_outbound_acl_rules = [
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 0,
      "protocol" : "-1",
      "rule_action" : "allow",
      "rule_number" : 100,
      "to_port" : 0
    }
  ]
  #private_subnet_names
  public_dedicated_network_acl = false
  public_inbound_acl_rules = [
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 0,
      "protocol" : "-1",
      "rule_action" : "allow",
      "rule_number" : 100,
      "to_port" : 0
    }
  ]
  public_outbound_acl_rules = [
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 0,
      "protocol" : "-1",
      "rule_action" : "allow",
      "rule_number" : 100,
      "to_port" : 0
    }
  ]
  tags = {
    Terraform = "true"
    For       = "EKS-setup"
  }
  #create_igw = 
  #create_vpc =
  #default_network_acl_egress =
  #default_network_acl_ingress
  #default_network_acl_name
  #default_route_table_name
  #default_route_table_routes
  #default_security_group_egress
  #default_security_group_ingress
  #default_security_group_name
  #enable_flow_log
}

#IAM roles & policies for EKS
#cluster role
# data "aws_iam_policy_document" "eks_cluster_assume_role_policy" {
#   statement {
#     principals {
#       type        = "Service"
#       identifiers = ["eks.amazonaws.com"]
#     }
#     actions = ["sts:AssumeRole"]
#     effect  = "Allow"
#   }
# }

# resource "aws_iam_role" "eks_cluster_role" {
#   name               = "Sample_EKS_cluster_role"
#   assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role_policy.json
# }
# resource "aws_iam_policy_attachment" "EKS_cluster_policy" {
#   name       = "EKS_cluster_policy"
#   roles      = [aws_iam_role.eks_cluster_role.name]
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
# }
#node iam role
# data "aws_iam_policy_document" "eks_node_assume_role_policy" {
#   statement {
#     effect = "Allow"
#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#     actions = ["sts:AssumeRole"]
#   }
# }
# resource "aws_iam_role" "eks_node_role" {
#   name               = "Sample_EKS_cluster_node_role"
#   assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role_policy.json
# }
# locals {
#   policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly", "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy", "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"]
# }
# resource "aws_iam_policy_attachment" "eks_node_policy_attachment" {
#   for_each   = toset(local.policy_arns)
#   name       = "EKS_cluster_policy_attachement"
#   roles      = [aws_iam_role.eks_node_role.name]
#   policy_arn = each.value
# }