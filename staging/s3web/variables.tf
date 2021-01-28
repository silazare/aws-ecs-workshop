# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "ecs_remote_state_bucket" {
  description = "The name of the S3 bucket used for the ECS remote state storage"
  type        = string
}

variable "ecs_remote_state_key" {
  description = "The name of the key in the S3 bucket used for the ECS remote state storage"
  type        = string
}

variable "ecs_remote_state_region" {
  description = "The region of S3 bucket used for the ECS remote state storage"
  type        = string
}

variable "ecs_dynamodb_table" {
  description = "The DynamoDB table used for ECS remote state lock"
  type        = string
}
