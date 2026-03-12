variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}

variable "spaces_access_id" {
  description = "DO Spaces access key ID"
  type        = string
  sensitive   = true
}

variable "spaces_secret_key" {
  description = "DO Spaces secret key"
  type        = string
  sensitive   = true
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
