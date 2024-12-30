resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Access Identity for S3 Bucket"
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = "${var.s3_bucket_name}.s3.amazonaws.com"
    origin_id   = "S3-${var.s3_bucket_name}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled      = true
  default_root_object  = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.s3_bucket_name}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    default_ttl            = 3600
    max_ttl                = 86400
    min_ttl                = 3600
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

output "cloudfront_url" {
  description = "The CloudFront URL to be used for DNS configuration."
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "cloudfront_arn" {
  description = "The ARN of the CloudFront distribution"
  value       = aws_cloudfront_distribution.cdn.arn
}

output "cdn" {
  value = aws_cloudfront_distribution.cdn.arn
}
