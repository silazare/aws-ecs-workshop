# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "vpc_remote_state_bucket" {
  description = "The name of the S3 bucket used for the VPC remote state storage"
  type        = string
}

variable "vpc_remote_state_key" {
  description = "The name of the key in the S3 bucket used for the VPC remote state storage"
  type        = string
}

variable "vpc_remote_state_region" {
  description = "The region of S3 bucket used for the VPC remote state storage"
  type        = string
}

variable "vpc_dynamodb_table" {
  description = "The DynamoDB table used for VPC remote state lock"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# Like Microservice parameters
# ---------------------------------------------------------------------------------------------------------------------

variable "like_chaos_mode" {
  description = "Like Microservice Chaos mode simulation"
  type        = string
  default     = "ON"
}

variable "like_loglevel" {
  description = "Like Microservice Loglevel"
  type        = string
  default     = "ERROR"
}