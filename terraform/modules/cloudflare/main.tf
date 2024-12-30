terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.16.0"
    }
  }
}

provider "cloudflare" {
  email   = "sherinbiju340@gmail.com"
  api_key = "094b2841f2d01be71f1052a4fe923aa549486"
}

resource "cloudflare_record" "cdn" {
  zone_id = "7b7ac7b35eb1deb71b6366bcec1ba3d3" # Replace with the actual Zone ID
  name    = "www"
  value   = var.cloudfront_url
  type    = "CNAME"
  ttl     = 3600
}

