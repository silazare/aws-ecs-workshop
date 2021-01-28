resource "aws_iam_role" "ecs_service" {
  name_prefix        = "mysfits-fargate-ecs-service-role"
  assume_role_policy = data.aws_iam_policy_document.assume_ecs_service.json
}

resource "aws_iam_policy" "ecs_service" {
  name_prefix = "mysfits-fargate-ecs-service-policy"
  policy      = data.aws_iam_policy_document.ecs_service.json
  path        = "/"
}

resource "aws_iam_role_policy_attachment" "ecs_service" {
  policy_arn = aws_iam_policy.ecs_service.arn
  role       = aws_iam_role.ecs_service.id
}

resource "aws_iam_role" "ecs_task" {
  name_prefix        = "mysfits-fargate-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.assume_ecs_task.json
}

resource "aws_iam_policy" "ecs_task" {
  name_prefix = "mysfits-fargate-ecs-task-policy"
  policy      = data.aws_iam_policy_document.ecs_task.json
  path        = "/"
}

resource "aws_iam_role_policy_attachment" "ecs_task" {
  policy_arn = aws_iam_policy.ecs_task.arn
  role       = aws_iam_role.ecs_task.id
}

resource "aws_iam_role" "ecs_autoscaling" {
  name_prefix        = "mysfits-fargate-ecs-asg-role"
  assume_role_policy = data.aws_iam_policy_document.assume_ecs_autoscaling.json
}

resource "aws_iam_role_policy_attachment" "ecs_autoscaling" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
  role       = aws_iam_role.ecs_autoscaling.id
}
