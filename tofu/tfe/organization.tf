resource "tfe_organization" "this" {
  name                     = "yutakobayashi"
  email                    = "hi@yutakobayashi.com"
  collaborator_auth_policy = "two_factor_mandatory"
}
