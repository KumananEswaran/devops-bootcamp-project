module "private_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "devops-private-sg"
  description = "Private subnet - controller and monitoring"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = {
    ssh = {
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      cidr_ipv4   = module.vpc.vpc_cidr_block
      description = "SSH from within VPC only"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  tags = { Project = "devops-bootcamp-final-project" }
}

module "public_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "devops-public-sg"
  description = "Public subnet - web server"
  vpc_id      = module.vpc.vpc_id

  ingress_rules = {
    http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
      description = "HTTP from anywhere"
    }
    node_exporter = {
      from_port                    = 9100
      to_port                      = 9100
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.private_sg.id
      description                  = "node_exporter scrape from monitoring server"
    }
    ssh = {
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      cidr_ipv4   = module.vpc.vpc_cidr_block
      description = "SSH from within VPC only"
    }
  }

  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  tags = { Project = "devops-bootcamp-final-project" }
}
