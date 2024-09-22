########### VPC variables

variable "azs" {
  description = "Availability zones"
  type        = list(string)
}

variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "enable_nat_gateway" {
  description = "Enable NAT gateway"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Use a single NAT gateway"
  type        = bool
  default     = true
}

variable "map_public_ip_on_launch" {
  description = "Map public IP on launch"
  type        = bool
  default     = false
}

variable "private_subnets" {
  description = "Private subnets CIDRs"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnets CIDRs"
  type        = list(string)
}

variable "private_dedicated_network_acl" {
  description = "Enable dedicated network ACL for private subnets"
  type        = bool
  default     = true
}

variable "private_inbound_acl_rules" {
  description = "Inbound ACL rules for private subnets"
  type        = list(object({
    cidr_block  = string,
    from_port   = number,
    protocol    = string,
    rule_action = string,
    rule_number = number,
    to_port     = number
  }))
  default = [
    {
      cidr_block  = "0.0.0.0/0",
      from_port   = 0,
      protocol    = "-1",
      rule_action = "allow",
      rule_number = 100,
      to_port     = 0
    }
  ]
}

variable "private_outbound_acl_rules" {
  description = "Outbound ACL rules for private subnets"
  type        = list(object({
    cidr_block  = string,
    from_port   = number,
    protocol    = string,
    rule_action = string,
    rule_number = number,
    to_port     = number
  }))
  default = [
    {
      cidr_block  = "0.0.0.0/0",
      from_port   = 0,
      protocol    = "-1",
      rule_action = "allow",
      rule_number = 100,
      to_port     = 0
    }
  ]
}

variable "public_dedicated_network_acl" {
  description = "Enable dedicated network ACL for public subnets"
  type        = bool
  default     = false
}

variable "public_inbound_acl_rules" {
  description = "Inbound ACL rules for public subnets"
  type        = list(object({
    cidr_block  = string,
    from_port   = number,
    protocol    = string,
    rule_action = string,
    rule_number = number,
    to_port     = number
  }))
  default = [
    {
      cidr_block  = "0.0.0.0/0",
      from_port   = 0,
      protocol    = "-1",
      rule_action = "allow",
      rule_number = 100,
      to_port     = 0
    }
  ]
}

variable "public_outbound_acl_rules" {
  description = "Outbound ACL rules for public subnets"
  type        = list(object({
    cidr_block  = string,
    from_port   = number,
    protocol    = string,
    rule_action = string,
    rule_number = number,
    to_port     = number
  }))
  default = [
    {
      cidr_block  = "0.0.0.0/0",
      from_port   = 0,
      protocol    = "-1",
      rule_action = "allow",
      rule_number = 100,
      to_port     = 0
    }
  ]
}

variable "tags" {
  description = "Tags to assign to the resources"
  type        = map(string)
  default     = {
    Terraform = "true"
  }
}

variable "region" {
  type = string
  default = "eu-west-2"
}
