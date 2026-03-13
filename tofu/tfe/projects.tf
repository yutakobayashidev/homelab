resource "tfe_project" "default" {
  name         = "Default Project"
  organization = tfe_organization.this.name
}
