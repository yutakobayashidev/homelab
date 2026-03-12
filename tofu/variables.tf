variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
  default     = ""
}

variable "spaces_access_id" {
  description = "DO Spaces access key ID"
  type        = string
  sensitive   = true
  default     = ""
}

variable "spaces_secret_key" {
  description = "DO Spaces secret key"
  type        = string
  sensitive   = true
  default     = ""
}

variable "domain" {
  description = "Root domain name"
  type        = string
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "sgp1"
}

# Cloudflare

variable "cloudflare_api_token" {
  description = "認証用の Cloudflare API トークン"
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare アカウント ID"
  type        = string
  validation {
    condition     = can(regex("^[a-f0-9]{32}$", var.cloudflare_account_id))
    error_message = "アカウント ID は 32 文字の 16 進数文字列である必要があります。"
  }
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
  default     = null
}

# Mastodon

variable "mastodon_ip" {
  description = "Mastodon サーバーの IP アドレス（現在は Vultr、移行後は DO Droplet）"
  type        = string
  default     = "45.76.97.101" # Vultr IP
}

# Mastodon R2

variable "mastodon_media_bucket_name" {
  description = "Mastodon メディア用 R2 バケット名"
  type        = string
  default     = "fediverse"
}

variable "mastodon_media_custom_domain" {
  description = "Mastodon メディア用カスタムドメイン（例: media.social.example.com）"
  type        = string
  default     = null
}
