// ECS remote backend
data "terraform_remote_state" "ecs" {
  backend = "s3"

  config = {
    bucket         = var.ecs_remote_state_bucket
    key            = var.ecs_remote_state_key
    region         = var.ecs_remote_state_region
    dynamodb_table = var.ecs_dynamodb_table
    encrypt        = true
  }
}
