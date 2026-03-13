terraform {
  required_version = ">= 1.6"

  cloud {
    hostname     = "app.terraform.io"
    organization = "yutakobayashi"
    workspaces {
      name = "github"
    }
  }

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = "yutakobayashidev"
}
