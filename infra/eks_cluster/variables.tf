variable "eks_cluster_name" {
  type        = string
  default     = "Sample-cluster"
  description = "Name of the EKS cluster."
}

variable "endpoint_public_access" {
  type        = bool
  default     = true
  description = "Whether to enable public access to the EKS API server."
}

variable "endpoint_private_access" {
  type        = bool
  default     = false
  description = "Whether to enable private access to the EKS API server."
}

variable "cluster_addons" {
  type = list(string)
  default = [ ]
}

variable "log_types" {
  type = list(string)
  default = ["api", "audit"]
  description = "type of logs to collect from eks cluster"
}

variable "bootstrap_creator_admin_permissions" {
  type = bool
  default = true
}
variable "authentication_mode" {
  description = "The authentication mode for the cluster. Valid values are `CONFIG_MAP`, `API` or `API_AND_CONFIG_MAP`"
  type        = string
  default     = "API_AND_CONFIG_MAP"
}
variable "subnet_ids" {
  type = list(string)
  description = "list of subnet ids to launch cluster nodes"
}
variable "public_access_cidrs" {
  description = "List of CIDR blocks which can access public cluster endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "security_group_ids" {
  type = list(string)
  description = "Security groups to attach to cluster, NEED atlead ONE"
}
variable "tags" {
  type = map(string)
  default = {}
}

variable "additional_policies" {
  type = list(string)
  description = "list of additional policy arns to attach to node iam role"
  default = [ ]
}

variable "create_coredns" {
  type = bool
  default = true
}