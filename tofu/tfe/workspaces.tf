# Manage HCP Terraform workspaces as code

resource "tfe_workspace" "homelab" {
  name         = "homelab"
  organization = tfe_organization.this.name
  project_id   = tfe_project.default.id
  description  = "Homelab infrastructure (DO, Cloudflare, AWS)"

  file_triggers_enabled = false
  queue_all_runs        = false
}

resource "tfe_workspace_settings" "homelab" {
  workspace_id   = tfe_workspace.homelab.id
  execution_mode = "local"
}
