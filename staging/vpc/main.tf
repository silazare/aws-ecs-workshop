module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  name = "staging-vpc"
  cidr = "10.10.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.10.10.0/24", "10.10.11.0/24", "10.10.12.0/24"]
  public_subnets  = ["10.10.20.0/24", "10.10.21.0/24", "10.10.22.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false
  // Allows a container in the private subnet to talk to DynamoDB directly without needing to go via the NAT gateway.
  enable_dynamodb_endpoint = true

  tags = {
    Terraform   = "true"
    Environment = "staging"
  }
}

resource "aws_security_group" "mysfits_fargate" {
  name        = "mysfits-fargate"
  description = "Access to the fargate containers from the private subnets"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.10.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "mysfits-fargate"
    Terraform   = "true"
    Environment = "staging"
  }
}
