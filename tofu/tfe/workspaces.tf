# Manage HCP Terraform workspaces as code

resource "tfe_workspace" "homelab" {
  name         = "homelab"
  organization = "yutakobayashi"
  description  = "Homelab infrastructure (DO, Cloudflare, AWS)"

  file_triggers_enabled = false
  queue_all_runs        = false
}

resource "tfe_workspace_settings" "homelab" {
  workspace_id   = tfe_workspace.homelab.id
  execution_mode = "local"
}
