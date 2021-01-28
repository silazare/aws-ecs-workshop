output "website_url" {
  description = "The URL for S3 static website"
  value       = aws_s3_bucket.mysfits_fargate_web.website_endpoint
}