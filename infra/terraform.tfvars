azs=["eu-west-2a", "eu-west-2b", "eu-west-2c"]
cidr="10.0.0.0/16"
enable_nat_gateway=true
map_public_ip_on_launch=true
private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
private_inbound_acl_rules=[
    {
      cidr_block  = "10.0.0.0/16",
      from_port   = 0,
      protocol    = "-1",
      rule_action = "allow",
      rule_number = 100,
      to_port     = 0
    }
  ]
private_outbound_acl_rules=[
    {
      cidr_block  = "10.0.0.0/16",
      from_port   = 0,
      protocol    = "-1",
      rule_action = "allow",
      rule_number = 100,
      to_port     = 0
    }
  ]
public_dedicated_network_acl= true
public_inbound_acl_rules=[
    {
      cidr_block  = "0.0.0.0/0",
      from_port   = 80,
      protocol    = "tcp",
      rule_action = "allow",
      rule_number = 100,
      to_port     = 80
    },
    {
      cidr_block  = "0.0.0.0/0",
      from_port   = 1024,
      protocol    = "tcp",
      rule_action = "allow",
      rule_number = 200,
      to_port     = 65535
    }
  ]
public_outbound_acl_rules=[
    {
      cidr_block  = "0.0.0.0/0",
      from_port   = 80,
      protocol    = "tcp",
      rule_action = "allow",
      rule_number = 100,
      to_port     = 80
    },
    {
      cidr_block  = "0.0.0.0/0",
      from_port   = 443,
      protocol    = "tcp",
      rule_action = "allow",
      rule_number = 200,
      to_port     = 443
    },
    {
      cidr_block  = "0.0.0.0/0",
      from_port   = 1024,
      protocol    = "tcp",
      rule_action = "allow",
      rule_number = 300,
      to_port     = 65535
    }
  ]