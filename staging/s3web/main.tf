// S3 static website bucket
# tfsec:ignore:AWS002
resource "aws_s3_bucket" "mysfits_fargate_web" {
  bucket        = "mysfits-fargate-web-21082020"
  force_destroy = "true"
  request_payer = "BucketOwner"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled    = "true"
    mfa_delete = "false"
  }

  website {
    error_document = "error.html"
    index_document = "index.html"
  }
}

// S3 deploy static website content
resource "aws_s3_bucket_object" "mysfits_fargate_html" {
  for_each = fileset("${path.module}/website-files/html", "*")

  bucket = "mysfits-fargate-web-21082020"
  key    = each.value
  source = "${path.module}/website-files/html/${each.value}"
  acl    = "public-read"
  // etag makes the file update when it changes
  etag         = filemd5("${path.module}/website-files/html/${each.value}")
  content_type = "text/html"

  depends_on = [aws_s3_bucket.mysfits_fargate_web]
}

resource "aws_s3_bucket_object" "mysfits_fargate_template" {
  for_each = fileset("${path.module}/website-files/template", "*")

  bucket = "mysfits-fargate-web-21082020"
  key    = each.value
  acl    = "public-read"
  content = templatefile(
    "${path.module}/website-files/template/${each.value}",
    {
      mysfits_api_endpoint = data.terraform_remote_state.ecs.outputs.alb_dns_name
      mysfits_aws_region   = "eu-west-1"
    }
  )
  content_type = "text/html"

  depends_on = [aws_s3_bucket.mysfits_fargate_web]
}

resource "aws_s3_bucket_object" "mysfits_fargate_folder" {
  bucket = "mysfits-fargate-web-21082020"
  key    = "js/"
  source = "/dev/null"

  depends_on = [aws_s3_bucket.mysfits_fargate_web]
}

resource "aws_s3_bucket_object" "mysfits_fargate_js" {
  for_each = fileset("${path.module}/website-files/js", "*")

  bucket = "mysfits-fargate-web-21082020"
  key    = "js/${each.value}"
  source = "${path.module}/website-files/js/${each.value}"
  acl    = "public-read"
  // etag makes the file update when it changes
  etag         = filemd5("${path.module}/website-files/js/${each.value}")
  content_type = "text/javascript"

  depends_on = [aws_s3_bucket.mysfits_fargate_web]
}
