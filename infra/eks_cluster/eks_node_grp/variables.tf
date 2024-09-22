variable "node_group_name" {
  description = "Name of the EKS node group"
  type        = string
}

variable "desired_size" {
  description = "Desired number of instances in the node group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in the node group"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "Minimum number of instances in the node group"
  type        = number
  default     = 1
}

variable "max_unavailable" {
  description = "The maximum number of unavailable nodes during the update"
  type        = number
  default     = 1
}

variable "cluster_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "additional_policies" {
  type = list(string)
  description = "list of additional policy arns to attach to node iam role"
  default = [ ]
}