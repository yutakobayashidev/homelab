output "bucket_name" {
  description = "R2バケットの名前"
  value       = cloudflare_r2_bucket.this.name
}

output "bucket_id" {
  description = "R2バケットのID"
  value       = cloudflare_r2_bucket.this.id
}
