resource "github_repository" "grafanaconf" {
  name        = "grafanaconf"
  visibility  = "public"
  archived    = true
  description = "Archived: merged into yutakobayashidev/homelab"

  has_issues    = true
  has_projects  = true
  has_wiki      = true
  has_downloads = true

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = true
}

resource "github_repository" "daily_report" {
  name        = "daily-report"
  visibility  = "public"
  archived    = true
  description = "Archived: use ryoppippi/gh-nippou instead"

  has_issues    = true
  has_projects  = true
  has_wiki      = true
  has_downloads = true

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  delete_branch_on_merge = false
}
