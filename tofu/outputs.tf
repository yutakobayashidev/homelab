# Mastodon R2
output "mastodon_r2_access_key_id" {
  description = "Mastodon 用 R2 アクセスキー ID"
  value       = module.mastodon_r2_token.access_key_id
}

output "mastodon_r2_secret_access_key" {
  description = "Mastodon 用 R2 シークレットアクセスキー"
  value       = module.mastodon_r2_token.secret_access_key
  sensitive   = true
}

output "mastodon_r2_endpoint" {
  description = "Mastodon 用 R2 エンドポイント URL"
  value       = "https://${var.cloudflare_account_id}.r2.cloudflarestorage.com"
}

output "mastodon_r2_bucket_name" {
  description = "Mastodon メディア R2 バケット名"
  value       = module.mastodon_media.bucket_name
}

# TODO: Add outputs when Mastodon Droplet is created
# output "mastodon_ip" {
#   description = "Mastodon Droplet public IP"
#   value       = digitalocean_droplet.mastodon.ipv4_address
# }
