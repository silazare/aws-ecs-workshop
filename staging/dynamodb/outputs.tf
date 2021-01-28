output "mysfits_fargate_table_arn" {
  description = "The DynamoDB table ARN"
  value       = aws_dynamodb_table.mysfits_fargate.arn
}

