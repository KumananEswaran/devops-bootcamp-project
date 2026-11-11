# Permanent resources that CI depends on. Lives in its own config and state key
# so the session-by-session `terraform destroy` of ../ never removes it.
terraform {
  required_version = ">= 1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "devops-bootcamp-terraform-kumanan"
    key          = "final-project/bootstrap.tfstate"
    region       = "ap-southeast-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "ap-southeast-1"
}
