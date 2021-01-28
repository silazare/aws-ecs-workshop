// ECS resources
resource "aws_ecs_cluster" "this" {
  name = "mysfits-fargate-cluster"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  tags = {
    Name        = "mysfits-fargate-cluster"
    Terraform   = "true"
    Environment = "staging"
  }
}

resource "aws_ecs_task_definition" "mysfits_monolith" {
  family                   = "mysfits-monolith-fargate"
  container_definitions    = local.monolith_service
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.ecs_task.arn
  execution_role_arn       = aws_iam_role.ecs_service.arn

  tags = {
    Name        = "mysfits-monolith-fargate"
    Terraform   = "true"
    Environment = "staging"
  }
}

resource "aws_ecs_task_definition" "mysfits_like" {
  family                   = "mysfits-like-fargate"
  container_definitions    = local.like_service
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  task_role_arn            = aws_iam_role.ecs_task.arn
  execution_role_arn       = aws_iam_role.ecs_service.arn

  tags = {
    Name        = "mysfits-like-fargate"
    Terraform   = "true"
    Environment = "staging"
  }
}

resource "aws_ecs_service" "mysfits_monolith" {
  name                               = "mysfits-monolith-fargate"
  cluster                            = aws_ecs_cluster.this.id
  task_definition                    = aws_ecs_task_definition.mysfits_monolith.arn
  desired_count                      = 1
  scheduling_strategy                = "REPLICA"
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  // FARGATE launch cannot use custom IAM Roles in Terraform, only default.
  #iam_role   = aws_iam_role.ecs_service.arn
  #depends_on = [aws_iam_role.ecs_service, aws_iam_policy.ecs_service]

  network_configuration {
    subnets          = data.aws_subnet_ids.private.ids
    security_groups  = [data.aws_security_group.fargate.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.mysfits_monolith.arn
    container_name   = "monolith-service"
    container_port   = 80
  }
}

resource "aws_ecs_service" "mysfits_like" {
  name                               = "mysfits-like-fargate"
  cluster                            = aws_ecs_cluster.this.id
  task_definition                    = aws_ecs_task_definition.mysfits_like.arn
  desired_count                      = 1
  scheduling_strategy                = "REPLICA"
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  network_configuration {
    subnets          = data.aws_subnet_ids.private.ids
    security_groups  = [data.aws_security_group.fargate.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.mysfits_like.arn
    container_name   = "like-service"
    container_port   = 80
  }
}
