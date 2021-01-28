// VPC remote backend
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket         = var.vpc_remote_state_bucket
    key            = var.vpc_remote_state_key
    region         = var.vpc_remote_state_region
    dynamodb_table = var.vpc_dynamodb_table
    encrypt        = true
  }
}

// Custom VPC datasources
data "aws_vpc" "custom" {
  id = data.terraform_remote_state.vpc.outputs.vpc_id
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.custom.id

  filter {
    name   = "tag:Name"
    values = ["*public*"]
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.custom.id

  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

data "aws_security_group" "fargate" {
  vpc_id = data.aws_vpc.custom.id

  filter {
    name   = "tag:Name"
    values = ["mysfits-fargate"]
  }
}

data "aws_route_tables" "private" {
  vpc_id = data.aws_vpc.custom.id

  filter {
    name   = "tag:Name"
    values = ["*private*"]
  }
}

// ECR datasources
data "aws_ecr_repository" "mysfits_monolith" {
  name = "mysfits-monolith"
}

data "aws_ecr_repository" "mysfits_like" {
  name = "mysfits-like"
}

data "aws_ecr_repository" "mysfits_xray" {
  name = "mysfits-xray"
}

// DynamoDB datasource
data "aws_dynamodb_table" "mysfits_fargate" {
  name = "mysfits-fargate-table"
}

// IAM policies
data "aws_iam_policy_document" "ecs_service" {
  statement {
    actions = [
      "ec2:AttachNetworkInterface",
      "ec2:CreateNetworkInterface",
      "ec2:CreateNetworkInterfacePermission",
      "ec2:DeleteNetworkInterface",
      "ec2:DeleteNetworkInterfacePermission",
      "ec2:Describe*",
      "ec2:DetachNetworkInterface",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
      "iam:PassRole",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:DescribeLogStreams",
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "ecs_task" {
  statement {
    actions = [
      "ec2:AttachNetworkInterface",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:PutLogEvents",
      "xray:PutTraceSegments",
      "xray:PutTelemetryRecords",
      "xray:GetSamplingRules",
      "xray:GetSamplingTargets",
      "xray:GetSamplingStatisticSummaries"
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "dynamodb:Scan",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:GetItem",
    ]

    resources = [data.aws_dynamodb_table.mysfits_fargate.arn]
  }
}

data "aws_iam_policy_document" "assume_ecs_service" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "assume_ecs_task" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "assume_ecs_autoscaling" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["application-autoscaling.amazonaws.com"]
      type        = "Service"
    }
  }
}
