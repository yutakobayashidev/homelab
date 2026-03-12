terraform {
  required_version = ">= 1.6"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }

  # Uncomment after bootstrapping the Spaces bucket
  # backend "s3" {
  #   endpoints = {
  #     s3 = "https://sgp1.digitaloceanspaces.com"
  #   }
  #   bucket                      = "homelab-tfstate"
  #   key                         = "terraform.tfstate"
  #   region                      = "us-east-1" # required but ignored by DO
  #   skip_credentials_validation = true
  #   skip_requesting_account_id  = true
  #   skip_metadata_api_check     = true
  #   skip_s3_checksum            = true
  # }
}

provider "digitalocean" {
  token             = var.do_token
  spaces_access_id  = var.spaces_access_id
  spaces_secret_key = var.spaces_secret_key
}

# TODO: Add resources when migrating Mastodon from Vultr
# - digitalocean_droplet (Mastodon)
# - digitalocean_domain + records (DNS)
# - digitalocean_spaces_bucket (media + backups)
