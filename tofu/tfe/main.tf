terraform {
  required_version = ">= 1.6"

  cloud {
    hostname     = "app.terraform.io"
    organization = "yutakobayashi"
    workspaces {
      name = "tfe"
    }
  }

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.65"
    }
  }
}

provider "tfe" {
  organization = "yutakobayashi"
}
