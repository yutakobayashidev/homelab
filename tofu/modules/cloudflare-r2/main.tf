resource "cloudflare_r2_bucket" "this" {
  account_id = var.cloudflare_account_id
  name       = var.bucket_name
  location   = var.r2_location
}

resource "cloudflare_r2_custom_domain" "this" {
  count       = var.custom_domain != null ? 1 : 0
  account_id  = var.cloudflare_account_id
  bucket_name = cloudflare_r2_bucket.this.name
  domain      = var.custom_domain
  zone_id     = var.zone_id
  enabled     = true
}
