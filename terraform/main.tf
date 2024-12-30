	provider "aws" {
  region = "us-east-1"
}

provider "cloudflare" {
  email   = "sherinbiju340@gmail.com"
  api_key = "094b2841f2d01be71f1052a4fe923aa549486"
}

terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.16.0"
    }
  }
  required_version = ">= 1.0.0"
}

module "s3" {
  source = "./modules/s3"
  s3_bucket_name = "kadathanadonlineshope-life"  # Use the desired S3 bucket name
  cloudfront_arn = module.cloudfront.cloudfront_arn  # Pass CloudFront ARN here
}


module "cloudfront" {
  source         = "./modules/cloudfront"
  s3_bucket_name = module.s3.bucket_name
}

module "cloudflare" {
  source          = "./modules/cloudflare"
  cloudfront_url  = module.cloudfront.cloudfront_url
}
output "website_url" {
  value = module.s3.website_url
}




