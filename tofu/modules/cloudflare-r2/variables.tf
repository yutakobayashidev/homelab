variable "cloudflare_account_id" {
  description = "Cloudflare アカウント ID"
  type        = string
  validation {
    condition     = can(regex("^[a-f0-9]{32}$", var.cloudflare_account_id))
    error_message = "アカウント ID は 32 文字の 16 進数文字列である必要があります。"
  }
}

variable "r2_location" {
  description = "R2 バケットのリージョン"
  type        = string
  default     = "APAC"
  validation {
    condition     = contains(["APAC", "EEUR", "ENAM", "WEUR", "WNAM", "OC"], var.r2_location)
    error_message = "R2 のリージョンは次のいずれかである必要があります: APAC, EEUR, ENAM, WEUR, WNAM, OC。"
  }
}

variable "bucket_name" {
  description = "R2 バケット名"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.bucket_name))
    error_message = "バケット名は小文字のアルファベット、数字、ハイフンのみを使用し、先頭と末尾は英数字である必要があります。"
  }
}

variable "custom_domain" {
  description = "Cloudflare R2 のカスタムドメイン（例: media.example.com）"
  type        = string
  default     = null
}

variable "zone_id" {
  description = "カスタムドメインに関連付けられた Cloudflare Zone ID"
  type        = string
  default     = null
}
