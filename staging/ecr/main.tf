// ECR resources
resource "aws_ecr_repository" "mysfits_monolith" {
  name                 = "mysfits-monolith"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "mysfits_like" {
  name                 = "mysfits-like"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "mysfits_xray" {
  name                 = "mysfits-xray"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}