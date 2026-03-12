terraform {
  required_version = ">= 1.6"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.10.1"
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

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

# Cloudflare R2 - Mastodon media storage
module "mastodon_media" {
  source                = "./modules/cloudflare-r2"
  cloudflare_account_id = var.cloudflare_account_id
  r2_location           = "APAC"
  bucket_name           = var.mastodon_media_bucket_name
  custom_domain         = var.mastodon_media_custom_domain
  zone_id               = var.cloudflare_zone_id
}

# Cloudflare R2 Access Token - Mastodon
module "mastodon_r2_token" {
  source                = "./modules/cloudflare-account-token"
  project_name          = "homelab"
  environment           = "prod"
  token_name            = "mastodon-r2"
  bucket_name           = module.mastodon_media.bucket_name
  cloudflare_account_id = var.cloudflare_account_id
}

# TODO: Add resources when migrating Mastodon from Vultr
# - digitalocean_droplet (Mastodon)
# - digitalocean_domain + records (DNS)
# - digitalocean_spaces_bucket (backups)
