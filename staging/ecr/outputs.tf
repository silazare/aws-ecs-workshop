output "mysfits_monolith" {
  description = "The registry id of mysfits monolith repository"
  value       = aws_ecr_repository.mysfits_monolith.repository_url
}

output "mysfits_like" {
  description = "The registry id of mysfits like repository"
  value       = aws_ecr_repository.mysfits_like.repository_url
}

output "mysfits_xray" {
  description = "The registry id of mysfits x-ray repository"
  value       = aws_ecr_repository.mysfits_xray.repository_url
}
