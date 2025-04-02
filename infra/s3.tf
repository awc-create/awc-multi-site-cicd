resource "aws_s3_bucket" "static_site" {
  bucket = "${var.project_name}-site"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "404.html"
  }

  tags = {
    Project = var.project_name
  }
}

resource "aws_s3_bucket_policy" "allow_public_read" {
  bucket = aws_s3_bucket.static_site.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = "*",
        Action = ["s3:GetObject"],
        Resource = ["${aws_s3_bucket.static_site.arn}/*"]
      }
    ]
  })
}
