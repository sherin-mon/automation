# Data source to fetch the current AWS region
data "aws_region" "current" {}

# Define the S3 Bucket Policy to allow public access to the bucket
resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = var.s3_bucket_name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = "s3:GetObject"
        Resource = "arn:aws:s3:::${var.s3_bucket_name}/*"
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = "s3:GetObject"
        Resource = "arn:aws:s3:::${var.s3_bucket_name}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::891377267870:distribution/E3H6N14QH007PK"
          }
        }
      }
    ]
  })
}
# Define the S3 Bucket for hosting the static website
resource "aws_s3_bucket" "static_website" {
  bucket = var.s3_bucket_name

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  force_destroy = true  # Allow the bucket to be destroyed with objects in it
}

# Configure Block Public Access on the S3 Bucket
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.static_website.bucket

  block_public_acls       = false  # Allow public ACLs
  block_public_policy     = false
  ignore_public_acls      = false  # Allow public ACLs
  restrict_public_buckets = false
}

# Upload the index.html to the S3 bucket (without ACL)
resource "aws_s3_object" "website_object" {
  bucket       = aws_s3_bucket.static_website.bucket
  key          = "index.html"
  source       = "/home/sherin-mon-biju/aslam/website/index.html"
  content_type = "text/html"
}

# Upload the error.html to the S3 bucket (without ACL)
resource "aws_s3_object" "error_page" {
  bucket       = aws_s3_bucket.static_website.bucket
  key          = "error.html"
  source       = "/home/sherin-mon-biju/aslam/website/error.html"
  content_type = "text/html"
}

# Output the bucket name
output "bucket_name" {
  value = aws_s3_bucket.static_website.bucket
}

# Output the website URL
output "website_url" {
  value = "http://${aws_s3_bucket.static_website.bucket}.s3-website-${data.aws_region.current.name}.amazonaws.com"
}
resource "aws_s3_bucket_cors_configuration" "cors" {
  bucket = aws_s3_bucket.static_website.bucket

  cors_rule {
    allowed_methods = ["GET"]
    allowed_origins = ["*"]  # Adjust as needed for security
    allowed_headers = ["*"]
  }
}
