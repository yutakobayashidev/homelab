output "token" {
  value       = cloudflare_api_token.this.value
  sensitive   = true
  description = "Token value"
}

output "access_key_id" {
  value       = cloudflare_api_token.this.id
  description = "Access Key ID"
}

output "secret_access_key" {
  value       = sha256(cloudflare_api_token.this.value)
  sensitive   = true
  description = "Secret Access Key"
}

output "name" {
  value       = cloudflare_api_token.this.name
  description = "Name of the API Token"
}
